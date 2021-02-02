# Sentry

## First run 
Go to server and run
```bash
nixops ssh -d thinkglobal.online sentry
docker exec -it <container-id> sentry upgrade
```

Then enable `-e SENTRY_SINGLE_ORGANIZATION=false` in docker env

```
docker ps -a
docker exec -it 331b6fc85edb sentry upgrade
docker exec -it 331b6fc85edb sentry createuser
systemctl stop sentry*
journalctl -u nginx -r
journalctl -u sentry_web -r
systemctl status sentry
systemctl stop sentry*
```