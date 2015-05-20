# Vhost
Shell script para gerenciar vhosts de um servidor local para teste.

Uso:

	su ./vhost.sh -h
	Exibi uma ajuda.

	su ./vhost.sh -l
	Exibi uma lista dos vhosts criados.

	su ./vhost.sh -c site.local [/var/www/pasta]
	Cria um vhost com a url "site.local".

	su ./vhost.sh -d site.local
	Desabilita o vhost "site.local".

	su ./vhost.sh -u site.local
	Habilita o vhost "site.local".
