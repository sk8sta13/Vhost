# Vhost
Shell script para gerenciar vhosts de um servidor local para teste.

Uso:

	su ./vhost.sh -help
	Exibi uma ajuda.

	su ./vhost.sh -list
	Exibi uma lista dos vhosts criados.

	su ./vhost.sh -create site.local
	Cria um vhost com a url "site.local".

	su ./vhost.sh -disable site.local
	Desabilita o vhost "site.local".

	su ./vhost.sh -enable site.local
	Habilita o vhost "site.local".

	su ./vhost.sh -delete site.local
	Desabilita o vhost "site.local" e deleta todos os arquivos.
