defmodule MPC do
  defmacro mpc(do: block) do
    quote do
      {ret, _} = Code.eval_string(~s(System.cmd "mpc", [#{unquote(block)}])) |> elem(0)
      ret
    end
  end
  defmacro fmt(format, do: block) do
    quote do
      ~s("--format", "#{unquote(format)}",) <>
      unquote(block)
    end
  end
  defmacro cmd(command, do: block) do
    quote do
      ~s("#{unquote(command)}",) <>
      unquote(block)
    end
  end
  defmacro cmd(command) do
    quote do
      ~s("#{unquote(command)}")
    end
  end
  defmacro type(type, do: block) do
    quote do
      ~s("#{unquote(type)}",) <>
      unquote(block)
    end
  end
  defmacro qry(query) do
    quote do
      ~s("#{unquote(query)}")
    end
  end
end

