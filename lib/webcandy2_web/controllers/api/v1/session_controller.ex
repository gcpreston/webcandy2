defmodule Webcandy2Web.API.V1.SessionController do
  use Webcandy2Web, :controller

  alias Plug.Conn
  alias Webcandy2Web.APIAuthPlug

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> case do 
      {:ok, conn} ->
        json(conn, %{token: conn.private[:api_access_token], renewal_token: conn.private[:api_renewal_token]})

      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{status: 401, message: "Invalid email or password"})
    end
    |> Conn.halt
  end

  @spec renew(Conn.t(), map()) :: Conn.t()
  def renew(conn, _params) do
    config = Pow.Plug.fetch_config(conn)

    conn
    |> APIAuthPlug.renew(config)
    |> case do
      {conn, nil} ->
        conn
        |> put_status(401)
        |> json(%{status: 401, message: "Invalid token"})

      {conn, _user} ->
        json(conn, %{token: conn.private[:api_access_token], renewal_token: conn.private[:api_renewal_token]})
    end
    |> Conn.halt
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, _params) do
    conn
    |> Pow.Plug.delete()
    |> json(%{})
    |> Conn.halt
  end
end
