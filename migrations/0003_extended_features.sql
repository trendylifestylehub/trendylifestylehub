PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS analytics_events (
 id TEXT PRIMARY KEY, event_type TEXT NOT NULL, page_path TEXT NOT NULL DEFAULT '', product_id TEXT, referrer TEXT NOT NULL DEFAULT '', session_key TEXT NOT NULL DEFAULT '', created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS analytics_created_idx ON analytics_events(created_at);
CREATE INDEX IF NOT EXISTS analytics_type_idx ON analytics_events(event_type,created_at);
CREATE TABLE IF NOT EXISTS ad_settings (
 id TEXT PRIMARY KEY, placement TEXT NOT NULL UNIQUE, enabled INTEGER NOT NULL DEFAULT 0, client_id TEXT NOT NULL DEFAULT '', slot_id TEXT NOT NULL DEFAULT '', format TEXT NOT NULL DEFAULT 'auto', updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS media_assets (
 id TEXT PRIMARY KEY, object_key TEXT NOT NULL UNIQUE, filename TEXT NOT NULL, content_type TEXT NOT NULL, size_bytes INTEGER NOT NULL, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
