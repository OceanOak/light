use std::env;

fn require_str(name: &str) -> String {
    env::var(name).unwrap_or_else(|_| panic!("{} must be set", name))
}

pub fn pusher_app_id() -> String {
    require_str("DARK_CONFIG_PUSHER_APP_ID")
}

pub fn pusher_key() -> String {
    require_str("DARK_CONFIG_PUSHER_KEY")
}

pub fn pusher_secret() -> String {
    require_str("DARK_CONFIG_PUSHER_SECRET")
}

pub fn pusher_host() -> String {
    require_str("DARK_CONFIG_PUSHER_HOST")
}