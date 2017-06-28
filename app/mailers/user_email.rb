class UserEmail < ApplicationMailer
	def bienvenido_email(user_inf)
	  @user = user_inf
	  @url  = 'http://miterra.com'
	  mail(to: user_inf.email, subject: '¡Bienvenido/a a MiTerra.com!')
	end
end
