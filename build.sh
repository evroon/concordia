PURPLE='\033[0;35m'
NC='\033[0m' # No Color

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd $SCRIPT_DIR

# Prepare files for installation
REPO_DIR=$(mktemp -d)
echo -e "${PURPLE}Using temporary directory: $REPO_DIR${NC}"

cp -r . $REPO_DIR
cd $REPO_DIR

sudo cp .env /root/.env

python3 check-dotenv.py || exit 1
python3 build.py $REPO_DIR

./install.sh
