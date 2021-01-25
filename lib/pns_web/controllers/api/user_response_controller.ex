defmodule PnsWeb.Api.UserResponseController do
  use PnsWeb, :controller

  alias Pns.Services.Api.UserResponse
  alias Pns.Services.Api.EventService

  def post_user_response_by_application_key(conn, %{
        "user" => user,
        "question_text" => question_text,
        "key" => key,
        "response" => response
      }) do
    event = EventService.get_current_event_by_application_key(key)

    attr = %{
      question_text: question_text,
      response: response,
      event_id: event.id,
      user: user
    }

    {:ok, data} = UserResponse.create_user_response(attr)
    render(conn, "response.json", data: data)
  end
end
