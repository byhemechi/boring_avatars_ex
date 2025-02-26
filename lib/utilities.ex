defmodule BoringAvatars.Utilities do
  @doc """
  Uses Erlang's phash2 function to generate a hash value from a string
  """
  def hash_code(name) do
    :erlang.phash2(name, 2_147_483_647)
  end

  @doc """
  Gets the modulus of a number
  """
  def get_modulus(num, max) do
    rem(num, max)
  end

  @doc """
  Gets a specific digit from a number
  """
  def get_digit(number, ntn) do
    div(number, round(:math.pow(10, ntn))) |> rem(10)
  end

  @doc """
  Returns a boolean based on a digit from the hash
  """
  def get_boolean(number, ntn) do
    rem(get_digit(number, ntn), 2) == 0
  end

  @doc """
  Calculates angle between x and y
  """
  def get_angle(x, y) do
    :math.atan2(y, x) * 180 / :math.pi()
  end

  @doc """
  Gets a value within a range, potentially negative based on the hash
  """
  def get_unit(number, range, index \\ nil) do
    value = rem(number, range)

    if index && rem(get_digit(number, index), 2) == 0 do
      -value
    else
      value
    end
  end

  @doc """
  Gets a random color from the provided colors list
  """
  def get_random_color(number, colors, range) do
    Enum.at(colors, rem(number, range))
  end

  @doc """
  Determines contrast color (black or white) for a given hex color
  """
  def get_contrast(hex_color) do
    # Remove # if present
    hex_color =
      if String.starts_with?(hex_color, "#"),
        do: String.slice(hex_color, 1..-1//1),
        else: hex_color

    # Convert to RGB
    {r, _} = Integer.parse(String.slice(hex_color, 0..1), 16)
    {g, _} = Integer.parse(String.slice(hex_color, 2..3), 16)
    {b, _} = Integer.parse(String.slice(hex_color, 4..5), 16)

    # Calculate YIQ ratio
    yiq = (r * 299 + g * 587 + b * 114) / 1000

    # Return contrast color
    if yiq >= 128, do: "#000000", else: "#FFFFFF"
  end
end
