defmodule MangoWeb.CategoryView do
  use MangoWeb, :view

  def title_case(title) do
    title
    |> String.downcase()
    |> String.capitalize()
  end
end
