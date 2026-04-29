defmodule BoringAvatars.Utilities do
  import Bitwise

  defmacro unique_id(opts) do
    quote do
      :crypto.hash(
        :sha,
        :erlang.term_to_binary({__MODULE__, unquote(opts)})
      )
      |> Base.encode32(case: :lower)
      |> String.slice(0..8)
    end
  end

  def hash_code(name) do
    name
    |> to_charlist()
    |> Enum.reduce(0, fn char, hash ->
      val = (hash <<< 5) - hash + char

      <<hash32::signed-size(32)>> = <<val::size(32)>>
      hash32
    end)
    |> abs()
  end

  def get_digit(number, ntn) do
    (number / :math.pow(10, ntn))
    |> :math.fmod(10)
    |> floor()
  end

  def get_boolean(number, ntn) do
    get_digit(number, ntn)
    |> rem(2)
    |> Kernel.==(0)
  end

  def get_angle(x, y) do
    :math.atan2(y, x) * 180 / :math.pi()
  end

  def get_unit(number, range, index \\ nil) do
    value = :math.fmod(number, range)

    if index && :math.fmod(get_digit(number, index), 2) == 0 do
      -value
    else
      value
    end
  end

  def get_random_colour(number, colours, range) do
    Enum.at(colours, rem(number, range))
  end

  def get_contrast(hexcolour) do
    hex = String.trim_leading(hexcolour, "#")

    # Slice the string and parse as base-16 integers
    r = String.slice(hex, 0..1) |> String.to_integer(16)
    g = String.slice(hex, 2..3) |> String.to_integer(16)
    b = String.slice(hex, 4..5) |> String.to_integer(16)

    yiq = (r * 299 + g * 587 + b * 114) / 1000

    if yiq >= 128 do
      "#000000"
    else
      "#FFFFFF"
    end
  end

  defmacro sigil_SVG({:<<>>, options, [source]}, []) do
    EEx.compile_string(
      source,
      engine: EEx.Engine,
      line: options[:line] + 1,
      file: options[:file],
      indentation: options[:indentation]
    )
  end
end
