import torch
from torch import nn


class SpikeFunction(torch.autograd.Function):

    @staticmethod
    def forward(ctx, x, alpha):
        # Save x for backward()
        ctx.save_for_backward(x)
        ctx.alpha = alpha

        # Actual spike function
        return (x >= 0).float()

    @staticmethod
    def backward(ctx, grad_output):
        x, = ctx.saved_tensors
        alpha = ctx.alpha

        sg_val = torch.sigmoid(alpha * x)

        pseudo_grad = (
            alpha
            * sg_val
            * (1.0 - sg_val)
        )

        grad_x = grad_output * pseudo_grad

        return grad_x, None


class LIFSpikeLayer(nn.Module):

    def __init__(
        self,
        beta=0.9,
        threshold=1.0,
        alpha=5.0
    ):
        super().__init__()

        self.beta = beta
        self.threshold = threshold
        self.alpha = alpha

        self.register_buffer(
            "membrane",
            None,
            persistent=False
        )

    def reset_state(self):
        self.membrane = None

    def detach_state(self):
        if self.membrane is not None:
            self.membrane = self.membrane.detach()

    def forward(self, input_current):

        if (
            self.membrane is None
            or self.membrane.shape != input_current.shape
        ):
            self.membrane = torch.zeros_like(input_current)

        self.membrane = (
            self.beta * self.membrane
            + input_current
        )

        shifted_membrane = (
            self.membrane - self.threshold
        )

        spikes = SpikeFunction.apply(
            shifted_membrane,
            self.alpha
        )

        self.membrane = (
            self.membrane
            * (1.0 - spikes.detach())
        )

        return spikes