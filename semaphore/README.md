# Semaphore Configuration

This directory contains configuration for the Semaphore Ansible UI.

## Security Notice ⚠️

**CRITICAL: The old admin password `skogsund1` was committed to git history!**

If you're setting up Semaphore for the first time or after the security checkup PR:

- **DO NOT use the old password** - it's permanently visible in git history
- **Generate a NEW secure password** (20+ characters, mixed case, numbers, symbols)

**NEVER commit the `.env` file to git - it contains sensitive credentials!**

The `.env` file is automatically excluded via `.gitignore`.

## Setup

1. **Copy the example environment file:**

   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` with your credentials:**

   ```bash
   nano .env  # or your preferred editor
   ```

3. **Set secure permissions:**

   ```bash
   chmod 600 .env
   ```

4. **Start Semaphore:**

   ```bash
   docker compose up -d
   ```

## Access

- **Local:** http://localhost:9005
- **Public:** https://semaphore.skogai.se (via Cloudflare tunnel)

## Default Credentials

The default credentials are specified in `.env.example`. **You MUST change these!**

## Security Recommendations

1. Use a strong password (20+ characters, mixed case, numbers, symbols)
2. Enable 2FA if available in Semaphore Pro
3. Restrict access via Cloudflare tunnel settings
4. Rotate credentials quarterly
5. Review audit logs regularly

## Troubleshooting

**Container won't start:**

```bash
# Check logs
docker compose logs

# Verify .env file exists
ls -la .env

# Restart container
docker compose restart
```

**Can't login:**

1. Verify credentials in `.env` file
2. Check if password was changed via UI
3. Reset by stopping container, removing data volume, and restarting

## Data Persistence

Semaphore data is stored in `./data/` directory:

- SQLite database
- Project configurations
- Task history
- User settings

**Backup regularly!** This directory is not committed to git.

## More Information

See the main repository documentation for integration with MCP and skogcli.
