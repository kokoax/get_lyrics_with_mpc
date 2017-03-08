defmodule GetLyricsWrapper do
  @moduledoc """
  Documentation for GetLyricsWithMpc.
  """

  @doc """
  Hello world.

  ## Examples

      iex> GetLyricsWithMpc.hello
      :world

  """
  require MPC
  import  MPC

  def main(opts) do
    {options, argv, _} = OptionParser.parse(opts,
      strict: [current: :boolean, search: :boolean],
      aliases:  [c: :current, s: :search]
    )
    options = options |> Enum.into(%{})
    {title, artist, composer} = cond do
      options |> Map.has_key?(:current) -> current()
      options |> Map.has_key?(:search)  -> search(argv)
      true -> {nil, nil, nil}
    end

    title    = title    |> optionConvert
    artist   = artist   |> optionConvert
    composer = composer |> optionConvert

    lyrics = System.cmd("get_lyrics", ["-t", title, "-a", artist, "-c", composer]) |> elem(0)
    lyrics = if !is_lyrics?(lyrics) do
      System.cmd("get_lyrics", ["-t", title, "-a", artist, "-c", ""]) |> elem(0)
    end

    IO.puts lyrics
  end

  defp is_lyrics?(lyrics) do
    Regex.match?(~r/Not Found/, lyrics)
  end

  defp current() do
    title    = mpc do: fmt "%title%"   , do: cmd "current"
    artist   = mpc do: fmt "%artist%"  , do: cmd "current"
    composer = mpc do: fmt "%composer%", do: cmd "current"
    {title, artist, composer}
  end

  defp search(arg) do
    type    = arg |> Enum.at(0)
    keyword = arg |> Enum.at(1)

    title    = mpc do: fmt "%title%"   , do: cmd "search", do: type type, do: qry keyword
    artist   = mpc do: fmt "%artist%"  , do: cmd "search", do: type type, do: qry keyword
    composer = mpc do: fmt "%composer%", do: cmd "search", do: type type, do: qry keyword
    {title, artist, composer}
  end

  defp removeNewLine(data) do
    Regex.replace(~r/\R/, data, "")
  end

  defp optionConvert(data) do
    data
      |> removeNewLine
  end
end

