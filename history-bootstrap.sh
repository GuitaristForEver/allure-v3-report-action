#!/bin/bash
# Bootstrap history for Allure v3
# Creates minimal history structure if none exists

RESULTS_DIR="$1"
HISTORY_DIR="${RESULTS_DIR}/history"

if [ ! -d "$HISTORY_DIR" ]; then
    echo "📝 Creating initial history structure..."
    mkdir -p "$HISTORY_DIR"

    # Create minimal history.json
    cat > "$HISTORY_DIR/history.json" << 'EOF'
{}
EOF

    # Create minimal history-trend.json
    cat > "$HISTORY_DIR/history-trend.json" << 'EOF'
[]
EOF

    # Create minimal duration-trend.json
    cat > "$HISTORY_DIR/duration-trend.json" << 'EOF'
[]
EOF

    # Create minimal retry-trend.json
    cat > "$HISTORY_DIR/retry-trend.json" << 'EOF'
[]
EOF

    # Create minimal categories-trend.json
    cat > "$HISTORY_DIR/categories-trend.json" << 'EOF'
[]
EOF

    echo "✅ History bootstrap complete"
else
    echo "ℹ️  History directory already exists"
fi
