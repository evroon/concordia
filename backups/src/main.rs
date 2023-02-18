use clap::Parser;
mod commands;
use crate::commands::list_backups;

/// Simple program to greet a person
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Name of the person to greet
    #[arg(short, long)]
    name: String,

    /// Number of times to greet
    #[arg(short, long, default_value_t = 1)]
    count: u8,
}

fn main() {
    let args = Args::parse();
    list_backups();

    for _ in 0..args.count {
        println!("Hello {}!", args.name)
    }
}
