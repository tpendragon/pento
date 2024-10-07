defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, reset_params(socket)}
  end

  def reset_params(socket) do
    assign(socket, score: 0, message: "Make a guess:", answer: Enum.random(1..10) |> to_string, won: false)
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, reset_params(socket)}
  end

  def handle_event("guess", %{"number" => guess}, socket = %{assigns: %{answer: guess}}) do
    message = "Your guess: #{guess}. Right!"
    score = socket.assigns.score + 1
    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        won: true
      )
    }
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    message = "Your guess: #{guess}. Wrong. Correct: #{socket.assigns.answer} Guess again."
    score = socket.assigns.score - 1
    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score
      )
    }
  end

  def time() do
    DateTime.utc_now |> to_string
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <br/>
    <h2>
      <%= if @won == false do %>
        <%= for n <- 1..10 do %>
          <.link class="bg-blue-500 hover:bg-blue-700
            text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess" phx-value-number= {n} >
            <%= n %>
          </.link>
        <% end %>
      <% else %>
          <.link class="bg-blue-500 hover:bg-blue-700
            text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
            patch="/guess">
            Restart
          </.link>
      <% end %>
    </h2>
    """
  end
end
