<footer>
    <div class="copyright">
        &#x1F1E8;&#x1F1E6; | &copy; 2026 Microbial Clinical Atlas. | All rights reserved.
    </div>
</footer>

<script>
    const searchInput = document.getElementById('microbe-search');
    const resultsDiv = document.getElementById('search-results');
    let selectedIndex = -1;

    if (searchInput && resultsDiv) {
        
        // 1. Live fetch suggestions
        searchInput.addEventListener('input', function() {
            const query = this.value.trim();
            selectedIndex = -1;
            
            if (query.length < 2) {
                resultsDiv.innerHTML = '';
                resultsDiv.style.display = 'none';
                return;
            }

            fetch(`ajax_search.php?q=${encodeURIComponent(query)}`)
                .then(response => response.json())
                .then(data => {
                    resultsDiv.innerHTML = '';
                    if (data && data.length > 0) {
                        data.forEach((item, index) => {
                            const div = document.createElement('div');
                            div.className = 'result-item';
                            let detail = '';
                            if (item.match_detail) {
                                detail = `<div style="font-size:11px;color:#aaa;margin-top:2px;">${item.match_detail}</div>`;
                            }
                            div.innerHTML = `<strong>${item.preferred_name}</strong> <small style="color:#888; margin-left:8px;">(${item.passport_id})</small>${detail}`;
                            
                            div.onclick = () => {
                                window.location.href = item.passport_id;
                            };
                            resultsDiv.appendChild(div);
                        });
                        resultsDiv.style.display = 'block';
                    } else {
                        resultsDiv.style.display = 'none';
                    }
                });
        });

        // 2. Keyboard logic (arrow keys & enter)
        searchInput.addEventListener('keydown', function(e) {
            const items = resultsDiv.querySelectorAll('.result-item');
            if (resultsDiv.style.display === 'none' || items.length === 0) return;

            if (e.key === 'ArrowDown') {
                e.preventDefault();
                selectedIndex = (selectedIndex + 1) % items.length;
                updateHighlight(items);
            } 
            else if (e.key === 'ArrowUp') {
                e.preventDefault();
                selectedIndex = (selectedIndex - 1 + items.length) % items.length;
                updateHighlight(items);
            } 
            else if (e.key === 'Enter') {
                e.preventDefault();
                const target = selectedIndex > -1 ? items[selectedIndex] : items[0];
                if (target) target.click();
            }
        });

        function updateHighlight(items) {
            items.forEach((item, index) => {
                if (index === selectedIndex) {
                    item.classList.add('selected');
                    item.scrollIntoView({ block: 'nearest' });
                } else {
                    item.classList.remove('selected');
                }
            });
        }

        document.addEventListener('click', (e) => {
            if (e.target !== searchInput) resultsDiv.style.display = 'none';
        });
    }
</script>
</body>
</html>