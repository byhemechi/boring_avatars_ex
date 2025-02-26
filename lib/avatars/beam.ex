defmodule BoringAvatars.Avatars.Beam do
  @moduledoc """
  Beam style avatar implementation
  """

  import Phoenix.Component
  alias BoringAvatars.Utilities

  @size 36

  defp generate_data(name, colors) do
    num_from_name = Utilities.hash_code(name)
    range = if colors, do: length(colors), else: 0
    wrapper_color = Utilities.get_random_color(num_from_name, colors, range)
    pre_translate_x = Utilities.get_unit(num_from_name, 10, 1)

    wrapper_translate_x =
      if pre_translate_x < 5, do: pre_translate_x + @size / 9, else: pre_translate_x

    pre_translate_y = Utilities.get_unit(num_from_name, 10, 2)

    wrapper_translate_y =
      if pre_translate_y < 5, do: pre_translate_y + @size / 9, else: pre_translate_y

    %{
      wrapper_color: wrapper_color,
      face_color: Utilities.get_contrast(wrapper_color),
      background_color: Utilities.get_random_color(num_from_name + 13, colors, range),
      wrapper_translate_x: wrapper_translate_x,
      wrapper_translate_y: wrapper_translate_y,
      wrapper_rotate: Utilities.get_unit(num_from_name, 360),
      wrapper_scale: 1 + Utilities.get_unit(num_from_name, div(@size, 12)) / 10,
      is_mouth_open: Utilities.get_boolean(num_from_name, 2),
      is_circle: Utilities.get_boolean(num_from_name, 1),
      eye_spread: Utilities.get_unit(num_from_name, 5),
      mouth_spread: Utilities.get_unit(num_from_name, 3),
      face_rotate: Utilities.get_unit(num_from_name, 10, 3),
      face_translate_x:
        if(wrapper_translate_x > @size / 6,
          do: wrapper_translate_x / 2,
          else: Utilities.get_unit(num_from_name, 8, 1)
        ),
      face_translate_y:
        if(wrapper_translate_y > @size / 6,
          do: wrapper_translate_y / 2,
          else: Utilities.get_unit(num_from_name, 7, 2)
        )
    }
  end

  def render(assigns) do
    data = generate_data(assigns.name, assigns.colors)
    mask_id = "mask_#{:erlang.phash2(assigns.name)}"

    size_attr =
      if Map.has_key?(assigns, :size), do: [width: assigns.size, height: assigns.size], else: []

    rx = if assigns.square, do: nil, else: @size * 2

    assigns =
      assign(assigns,
        data: data,
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
        <rect width={@size} height={@size} fill={@data.background_color} />
        <rect
          x="0"
          y="0"
          width={@size}
          height={@size}
          transform={"translate(#{@data.wrapper_translate_x} #{@data.wrapper_translate_y}) rotate(#{@data.wrapper_rotate} #{@size / 2} #{@size / 2}) scale(#{@data.wrapper_scale})"}
          fill={@data.wrapper_color}
          rx={if @data.is_circle, do: @size, else: @size / 6}
        />
        <g
          transform={"translate(#{@data.face_translate_x} #{@data.face_translate_y}) rotate(#{@data.face_rotate} #{@size / 2} #{@size / 2})"}
        >
          <%= if @data.is_mouth_open do %>
            <path
              d={"M15 #{19 + @data.mouth_spread}c2 1 4 1 6 0"}
              stroke={@data.face_color}
              fill="none"
              stroke-linecap="round"
            />
          <% else %>
            <path
              d={"M13,#{19 + @data.mouth_spread} a1,0.75 0 0,0 10,0"}
              fill={@data.face_color}
            />
          <% end %>
          <rect
            x={14 - @data.eye_spread}
            y={14}
            width={1.5}
            height={2}
            rx={1}
            stroke="none"
            fill={@data.face_color}
          />
          <rect
            x={20 + @data.eye_spread}
            y={14}
            width={1.5}
            height={2}
            rx={1}
            stroke="none"
            fill={@data.face_color}
          />
        </g>
      </g>
    </svg>
    """
  end
end
