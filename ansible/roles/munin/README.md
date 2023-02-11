# Useful Munin commands
### Listing commands to activate suggested plugins

```sh
sudo munin-node-configure --shell
```

### Activating a plugin
```sh
ln -s '/usr/share/munin/plugins/postgres_cache_' '/etc/munin/plugins/postgres_cache_gitea'
```
