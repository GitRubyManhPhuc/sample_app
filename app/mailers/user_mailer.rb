class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("user_mailer.account.subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("password_resets.new.reset_pass")
  end
end
