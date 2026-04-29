defmodule BoringAvatar.Variant.Ring do
  @size 90

  import BoringAvatar.Utilities
  import BoringAvatar.SVG

  @behaviour BoringAvatar

  def avatar(
        %BoringAvatar{
          name: name,
          colours: colours,
          title: title,
          size: size,
          square: square
        } = props
      ) do
    num_from_name = hash_code(name)
    range = length(colours)

    colours = &get_random_colour(num_from_name + &1, colours, range)

    mask_id = unique_id(props)

    svg(
      viewBox: "0 0 #{@size} #{@size}",
      fill: "none",
      role: "img",
      xmlns: "http://www.w3.org/2000/svg",
      width: size,
      height: size
    ) do
      if(title, do: title([], title), else: "")

      mask(
        id: mask_id,
        maskUnits: "userSpaceOnUse",
        x: 0,
        y: 0,
        width: @size,
        height: @size
      ) do
        rect(width: @size, height: @size, rx: if(square, do: 0, else: @size * 2), fill: "#FFFFFF")
      end

      g(mask: "url(##{mask_id})") do
        path(d: "M0 0h90v45H0z", fill: colours.(0))
        path(d: "M0 45h90v45H0z", fill: colours.(1))
        path(d: "M83 45a38 38 0 00-76 0h76z", fill: colours.(1))
        path(d: "M83 45a38 38 0 01-76 0h76z", fill: colours.(2))
        path(d: "M77 45a32 32 0 10-64 0h64z", fill: colours.(2))
        path(d: "M77 45a32 32 0 11-64 0h64z", fill: colours.(3))
        path(d: "M71 45a26 26 0 00-52 0h52z", fill: colours.(3))
        path(d: "M71 45a26 26 0 01-52 0h52z", fill: colours.(0))
        circle(cx: 45, cy: 45, r: 23, fill: colours.(4))
      end
    end
  end
end
