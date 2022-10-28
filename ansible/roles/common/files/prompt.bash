# Set the history format to something sensible.
export HISTTIMEFORMAT="%y-%m-%d %T "

# Set SECONDS to 0 before every command, and after every Ctrl+C so we can print
# timing information of individual commands automatically.
reset_seconds() {
  SECONDS=0
}
trap "reset_seconds" DEBUG
trap "reset_seconds" INT

# Prints the contents of the $SECONDS variable if it is greater than 5.
# Has a pretty format like: '1h 3m 5s'
command_duration() {
  let "HOURS=${SECONDS}/3600"
  let "MINUTES=(${SECONDS}%3600)/60"
  let "SECONDS_PRETTY=${SECONDS}%60"

  # Only print timing if the total command lasted for more than 5 seconds.
  if [ "$SECONDS" -gt "5" ]; then
    if [[ "$HOURS" -gt "0" ]]; then
      printf "${HOURS}h ${MINUTES}m ${SECONDS_PRETTY}s"
    elif [[ "$MINUTES" -gt "0" ]]; then
      printf "${MINUTES}m ${SECONDS_PRETTY}s"
    else
      printf "${SECONDS_PRETTY}s"
    fi
  fi
}
