# DWS

在一般 conv 中，如果说 `out_channel` 是 filters 的数量，那么 `in_channel` 就是 1 个 filter 中的 kernel 的数量。也正因此，kernel 数量等于 `in_channel * out_channel`。使用 1 个 filter 的多个 kernel 得到的多个单通道卷积结果加起来就是一个 feature map。

对于 DepthWise 来说，相较于使用多个 filter 提取多种特征，只使用等同于 channel 个数的 kernel。换句话说就是把原本的多对一映射（`in_channel` 到 feature map）改成了一对一。

在 torch 上是这样的：

```python
dw_conv = nn.Conv2d(in_channels=5, out_channels=10, kernel_size=3, groups=5)
```

`groups` 的意思是把 `in_channel` 划分为 n 份，每份用 `out_channel / n` 个 kernel 处理。上面这个产生了 10 个 3\*3 kernel，每个 `in_channel` 使用 2 个 kernel 处理。

对于 PointWise 来说，则是 `kernel_size` 为 1。其他与一般 conv 是一样的，只是 kernel size 不同。因此：

```python
pw_conv = nn.Conv2d(in_channels=10, out_channels=20, kernel_size=3)
```

于是一个 5 => 20 的 DWSConv 可以写成：

```python
dws_conv = nn.Sequential(
  nn.Conv2d(in_channels=5, out_channels=10, kernel_size=3, groups=5),
  nn.SELU(),
  nn.Conv2d(in_channels=10, out_channels=20, kernel_size=3),
  nn.SELU()
)
```

