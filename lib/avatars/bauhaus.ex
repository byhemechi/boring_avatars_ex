defmodule BoringAvatars.Avatars.Bauhaus do
  @moduledoc """
  Bauhaus style avatar implementation
  """

  import Phoenix.Component
  alias BoringAvatars.Utilities

  @elements 4
  @size 80

  defp generate_colors(name, colors) do
    num_from_name = Utilities.hash_code(name)
    range = if colors, do: length(colors), else: 0

    Enum.map(0..(@elements - 1), fn i ->
      %{
        color: Utilities.get_random_color(num_from_name + i, colors, range),
        translate_x: Utilities.get_unit(num_from_name * (i + 1), div(@size, 2) - (i + 17), 1),
        translate_y: Utilities.get_unit(num_from_name * (i + 1), div(@size, 2) - (i + 17), 2),
        rotate: Utilities.get_unit(num_from_name * (i + 1), 360),
        is_square: Utilities.get_boolean(num_from_name, 2)
      }
    end)
  end

  def render(assigns) do
    properties = generate_colors(assigns.name, assigns.colors)
    mask_id = "mask_#{:erlang.phash2(assigns.name)}"

    size_attr =
      if Map.has_key?(assigns, :size), do: [width: assigns.size, height: assigns.size], else: []

    rx = if assigns.square, do: nil, else: @size * 2

    assigns =
      assign(assigns,
        properties: properties,
        mask_id: mask_id,
        size: @size,
        size_attr: size_attr,
        rx: rx
      )

    ~H"""
    <svg
      viewBox={"0 0 #{@size} #{@size}"}
      fill="none"
      role="img"
      xmlns="http://www.w3.org/2000/svg"
      {@size_attr}
    >
      <%= if @title do %>
        <title><%= @name %></title>
      <% end %>
      <mask id={@mask_id} maskUnits="userSpaceOnUse" x={0} y={0} width={@size} height={@size}>
        <rect width={@size} height={@size} rx={@rx} fill="#FFFFFF" />
      </mask>
      <g mask={"url(##{@mask_id})"}>
        <rect width={@size} height={@size} fill={Enum.at(@properties, 0).color} />
        <rect
          x={(@size - 60) / 2}
          y={(@size - 20) / 2}
          width={@size}
          height={if Enum.at(@properties, 1).is_square, do: @size, else: @size / 8}
          fill={Enum.at(@properties, 1).color}
          transform={"translate(#{Enum.at(@properties, 1).translate_x} #{Enum.at(@properties, 1).translate_y}) rotate(#{Enum.at(@properties, 1).rotate} #{@size / 2} #{@size / 2})"}
        />
        <circle
          cx={@size / 2}
          cy={@size / 2}
          fill={Enum.at(@properties, 2).color}
          r={@size / 5}
          transform={"translate(#{Enum.at(@properties, 2).translate_x} #{Enum.at(@properties, 2).translate_y})"}
        />
        <line
          x1={0}
          y1={@size / 2}
          x2={@size}
          y2={@size / 2}
          strokeWidth={2}
          stroke={Enum.at(@properties, 3).color}
          transform={"translate(#{Enum.at(@properties, 3).translate_x} #{Enum.at(@properties, 3).translate_y}) rotate(#{Enum.at(@properties, 3).rotate} #{@size / 2} #{@size / 2})"}
        />
      </g>
    </svg>
    """
  end
end
