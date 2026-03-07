<?php
include 'header.php'; 
?>

<div class="page-content">
    <div class="logo-container">
        <a href="index.php" style="display: inline-block;">
            <img src="./images/logo.png" class="logo-main" alt="MCA Logo" style="cursor: pointer;">
        </a>
    </div>

    <div class="google-search-container" style="margin-top: 80px;">
        <input type="text" id="microbe-search" placeholder="Search by name (e.g. Enterobacteriaceae)" autocomplete="off" autofocus>
        <div id="search-results"></div>
    </div>
</div>

<script>
const searchInput = document.getElementById('microbe-search');
const resultsDiv = document.getElementById('search-results');
const placeholders = [
    "Search by name (e.g. Enterobacteriaceae)",
    "Search by synonym (e.g. Enterobacteraceae)",
    "Search by ID (e.g. MCA-BAC-000001)"
];
let currentPlaceholderIndex = 0;
let selectedIndex = -1;

// 1. Placeholder Rotation
setInterval(() => {
    currentPlaceholderIndex = (currentPlaceholderIndex + 1) % placeholders.length;
    searchInput.placeholder = placeholders[currentPlaceholderIndex];
}, 5000);

// 2. Search & Navigation Logic
searchInput.addEventListener('input', function() {
    const q = this.value.trim();
    if (q.length < 2) {
        resultsDiv.innerHTML = '';
        resultsDiv.style.display = 'none';
        return;
    }

    fetch(`search_handler.php?q=${encodeURIComponent(q)}`)
        .then(response => response.json())
        .then(data => {
            resultsDiv.innerHTML = '';
            selectedIndex = -1;
            
            if (data.length > 0) {
                resultsDiv.style.display = 'block';
                data.forEach((item, index) => {
                    const div = document.createElement('div');
                    div.className = 'search-item';
                    div.innerHTML = `<strong>${item.preferred_name}</strong> <span style="font-size:11px; color:#888;">(${item.passport_id})</span>`;
                    div.onclick = () => window.location.href = `passport.php?id=${item.passport_id}`;
                    resultsDiv.appendChild(div);
                });
            } else {
                resultsDiv.style.display = 'none';
            }
        });
});

// 3. Arrow Key & Enter Support
searchInput.addEventListener('keydown', function(e) {
    const items = resultsDiv.getElementsByClassName('search-item');
    if (items.length === 0) return;

    if (e.key === 'ArrowDown') {
        selectedIndex = (selectedIndex + 1) % items.length;
        updateSelection(items);
    } else if (e.key === 'ArrowUp') {
        selectedIndex = (selectedIndex - 1 + items.length) % items.length;
        updateSelection(items);
    } else if (e.key === 'Enter') {
        if (selectedIndex > -1) {
            items[selectedIndex].click();
        } else if (items.length === 1) {
            items[0].click();
        }
    }
});

function updateSelection(items) {
    Array.from(items).forEach((item, index) => {
        item.style.background = (index === selectedIndex) ? '#f0f0f0' : '#fff';
    });
}
</script>

<style>
    #search-results {
        position: absolute; width: 100%; background: #fff; border: 1px solid #ddd;
        border-top: none; max-height: 300px; overflow-y: auto; z-index: 1000; display: none;
    }
    .search-item { padding: 10px; cursor: pointer; border-bottom: 1px solid #eee; font-size: 14px; }
    .search-item:hover { background: #f9f9f9; }
</style>
</div>

<script>
    const searchInput = document.getElementById('microbe-search');
    const placeholders = [
        "Search by name (e.g. Enterobacteriaceae)",
        "Search by synonym (e.g. Enterobacteraceae)",
        "Search by ID (e.g. MCA-BAC-000001)"
    ];
    
    let currentIndex = 0;

    setInterval(() => {
        currentIndex = (currentIndex + 1) % placeholders.length;
        searchInput.placeholder = placeholders[currentIndex];
    }, 3000); // 3 seconds
</script>

<?php include 'footer.php'; ?>