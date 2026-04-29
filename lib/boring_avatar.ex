defmodule BoringAvatar do
  defstruct colours: ["#92A1C6", "#146A7C", "#F0AB3D", "#C271B4", "#C20D90"],
            name: "Clara Barton",
            title: false,
            size: "40px",
            square: false

  @callback avatar(%BoringAvatar{}) :: iodata()

  defdelegate bauhaus(props), to: BoringAvatar.Variant.Bauhaus, as: :avatar
  defdelegate beam(props), to: BoringAvatar.Variant.Beam, as: :avatar
  defdelegate marble(props), to: BoringAvatar.Variant.Marble, as: :avatar
  defdelegate pixel(props), to: BoringAvatar.Variant.Pixel, as: :avatar
  defdelegate ring(props), to: BoringAvatar.Variant.Ring, as: :avatar
  defdelegate sunset(props), to: BoringAvatar.Variant.Sunset, as: :avatar
end
