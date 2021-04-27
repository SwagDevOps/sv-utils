# Sv Utils

## ``svrun`` - avoid skeleton service burden

According to the [``runit-scripts``][runit-scripts]
([tarball][runit-scripts-tarball])
a minimal skeleton service (using [Alpine Linux][alpine-linux]) looks like:

```sh
#!/usr/bin/env sh
# /etc/sv/skeleton/run
set -eu

exec 2>&1

COMMAND=daemon
USER=root

exec /usr/bin/chpst -u ${USER} ${COMMAND}
```

See also:

* [Does runit support user-specific services?][runit-doc:userservices]

```sh
#!/usr/bin/env sh
# /etc/sv/skeleton/log/run
set -eu

SERVICE_NAME=`basename $(dirname $(dirname $(readlink -f $0)))`
LOG_DIR=/var/log/runit/${SERVICE_NAME}
USER=root
GROUP=root

# Create log dir and fix owner & mode
mkdir -p ${LOG_DIR}
chown ${USER}:${GROUP} ${LOG_DIR}
chmod 700 ${LOG_DIR}

exec /usr/bin/chpst -u ${USER} /usr/bin/svlogd -tt ${LOG_DIR}
```

Using ``sv-utils``:

```ruby
#!/usr/bin/env svrun

service('daemon').call
```

```ruby
#!/usr/bin/env svrun

loggerd.call
```

Moreover, options as ``:user`` and ``:group`` are supported
by ``loggerd`` and ``service`` methods, as:

```ruby
service('daemon', user: :john_doe).call
```

``:command``, defined in config for ``loggerd``, is used by default,
but it can be overriden (for example using [socklog][socklog]):

```ruby
#!/usr/bin/env svrun

loggerd(['svlogd', '-t', 'main/*'], user: :log).call
```

Log directory is created, under the hood, during ``loggerd`` call.

``sv-utils`` is an attempt to bring [DRY principle][dry-definition]
to ``runit`` services creation.

## See also

* [UNIX Programming by Example: Runit][sa:unix-programming-by-example-runit]

[alpine-linux]: https://alpinelinux.org/
[runit-scripts]: https://github.com/dockage/runit-scripts
[runit-scripts-tarball]: https://api.github.com/repos/dockage/runit-scripts/tarball
[socklog]: http://smarden.org/socklog/
[dry-definition]: https://en.wikipedia.org/wiki/Don%27t_repeat_yourself
[runit-doc:userservices]: http://smarden.org/runit/faq.html#userservices
[sa:unix-programming-by-example-runit]: http://tammersaleh.com/posts/unix-programming-by-example-runit/
