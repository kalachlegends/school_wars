defmodule SchoolWarsWeb.LoginFormLive do
  # use SchoolWarsWeb, :live_view

  # def mount(params, session, socket) do
  #   IO.inspect("_________________")
  #   IO.inspect(params)
  #   {:ok, socket}
  # end

  # def render(assigns) do
  #   ~L"""
  #   <%= form_for @conn, Routes.user_path(@conn, :login_submit), fn f -> %>
  #   <div class="input-block icon">
  #   <%= text_input f, :login, class: "input" %>

  #       <img src={Routes.static_path(@conn, "/images/icon/user.svg" )} alt="">
  #   </div>
  #   <div class="input-block icon">
  #   <%= text_input f, :password, class: "input" %>
  #       <img src={Routes.static_path(@conn, "/images/icon/lock-password.svg" )} alt="">
  #   </div>
  #   <button type="submit" class="btn-grey">
  #       Войти
  #   </button>
  #   <div class="df-aic-jc-fx-c gap-10">
  #       <a href="" class="text-align-center "> Забыли пароль?</a>
  #       <a href="" class="text-align-center width-80">Нету аккаунта? попросите администратора
  #           зарегировать
  #           вас,
  #           или вас нету в списке школ оставте заявку.</a>
  #   </div>
  #   <% end %>

  #   """
  # end
end
