use std::process::Command;

pub fn list_backups() {
    Command::new("ls")
    .arg("-l")
    .arg("-a")
    .spawn()
    .expect("ls command failed to start");
}
