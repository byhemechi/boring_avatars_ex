defmodule BoringAvatars do
  @callback avatar(%BoringAvatars.Props{} | keyword()) :: iodata()

  defdelegate bauhaus(props), to: BoringAvatars.Variant.Bauhaus, as: :avatar
  defdelegate beam(props), to: BoringAvatars.Variant.Beam, as: :avatar
  defdelegate marble(props), to: BoringAvatars.Variant.Marble, as: :avatar
  defdelegate pixel(props), to: BoringAvatars.Variant.Pixel, as: :avatar
  defdelegate ring(props), to: BoringAvatars.Variant.Ring, as: :avatar
  defdelegate sunset(props), to: BoringAvatars.Variant.Sunset, as: :avatar
end
