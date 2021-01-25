defmodule PnsWeb.Api.UserResponseView do
  use PnsWeb, :view

  alias PnsWeb.Api.UserResponseView

  def render("response.json", %{data: data}) do
    %{
      question_text: data.question_text,
      response: data.response
    }
  end
end
