const searchInput = document.getElementById('search');
const analyticsDiv = document.getElementById('analytics');
const showAnalyticsBtn = document.getElementById('show-analytics');
let lastQuery = '';
let debounceTimeout = null;

searchInput.addEventListener('input', function() {
  const query = searchInput.value;
  clearTimeout(debounceTimeout);
  debounceTimeout = setTimeout(() => {
    if (query.length > 3 && query !== lastQuery) {
      fetch('/search_logs', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ query })
      });
      lastQuery = query;
    }
  }, 1000);
});

showAnalyticsBtn.addEventListener('click', function() {
  fetch('/search_logs')
    .then(res => res.json())
    .then(data => {
      analyticsDiv.innerHTML = `
        <h2>Analytics</h2>
        <ul>
          ${data.analytics.map(a => `<li>${a.query}: ${a.count}</li>`).join('')}
        </ul>
        <h3>Recent Searches</h3>
        <ul>
          ${data.recent.map(r => `<li>${r[0]} (${r[1]})</li>`).join('')}
        </ul>
      `;
    });
});
