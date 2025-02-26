defmodule BoringAvatars do
  @moduledoc """
  Generates SVG avatars in different styles
  """

  alias BoringAvatars.Avatars.{Bauhaus, Ring, Pixel, Beam, Sunset, Marble}

  @default_colors ["#92A1C6", "#146A7C", "#F0AB3D", "#C271B4", "#C20D90"]
  @avatar_variants %{
    "pixel" => Pixel,
    "bauhaus" => Bauhaus,
    "ring" => Ring,
    "beam" => Beam,
    "sunset" => Sunset,
    "marble" => Marble
  }
  @deprecated_variants %{
    "geometric" => "beam",
    "abstract" => "bauhaus"
  }

  @doc """
  Renders an avatar as a Phoenix LiveView component.

  ## Options
    * `:variant` - The avatar style (default: "marble")
    * `:colors` - List of hex colors to use (default: predefined list)
    * `:name` - Name to generate avatar from (default: "Clara Barton")
    * `:title` - Whether to include a title (default: false)
    * `:size` - Size of the avatar (optional)
    * `:square` - Whether to make the avatar square (default: false)
  """
  def render(assigns) do
    assigns =
      assigns
      |> Map.put_new(:variant, "marble")
      |> Map.put_new(:colors, @default_colors)
      |> Map.put_new(:name, "Clara Barton")
      |> Map.put_new(:title, false)
      |> Map.put_new(:square, false)

    variant = Map.get(assigns, :variant)
    resolved_variant = Map.get(@deprecated_variants, variant, variant)

    avatar_module = Map.get(@avatar_variants, resolved_variant, Marble)
    avatar_module.render(assigns)
  end
end
