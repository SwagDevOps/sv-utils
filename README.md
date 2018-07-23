# Sv Utils

According to the [``runit-scripts``][runit-scripts] a skeleton service (using alpine):

```sh
#!/usr/bin/env sh
# /etc/sv/skeleton/run
set -eu

exec 2>&1

COMMAND=daemon
USER=root

exec /usr/bin/chpst -u ${USER} ${COMMAND}
```

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
# frozen_string_literal: true

runner(['daemon']).call
```

```ruby
#!/usr/bin/env svrun
# frozen_string_literal: true

logger.call
```

Moreover, options as ``:user`` are supported
by ``logger`` and ``runner`` methods, as:

```ruby
runner(['daemon'], user: :john_doe).call
```

``:user`` and ``:group`` options are also supported by the ``logger`` method,
but you SHOULD use config,
unless you need to set different user and/or group per service.

Log directory is created, under the hood, by the ``logger`` call.
``sv-utils`` attempts to follow the DRY principle.

[runit-scripts]: https://api.github.com/repos/dockage/runit-scripts/tarball
