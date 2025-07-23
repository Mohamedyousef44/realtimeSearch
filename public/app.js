const searchInput = document.getElementById('search');
const analyticsDiv = document.getElementById('analytics');
const showAnalyticsBtn = document.getElementById('show-analytics');

let lastQuery = '';
let debounceTimeout = null;

// Generate a new session ID when the user first loads the page
let sessionId = crypto.randomUUID();

searchInput.addEventListener('input', function () {
  const query = searchInput.value;
  clearTimeout(debounceTimeout);

  debounceTimeout = setTimeout(() => {
    if (query.length > 3 && query !== lastQuery) {
      fetch('/search_logs', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ query, session_id: sessionId })
      });
      lastQuery = query;
    }

    if (query.trim() === '') {
      sessionId = crypto.randomUUID(); // Start a new session
      lastQuery = '';
    }
  }, 1000);
});

showAnalyticsBtn.addEventListener('click', function () {
  fetch('/search_logs')
    .then(res => res.json())
    .then(data => {
      analyticsDiv.innerHTML = `
        <h2>Analytics</h2>
        <ul class="analytics-list">
          ${data.analytics.map(a => `<li>${a.query}: ${a.count}</li>`).join('')}
        </ul>
        <h3>Recent Searches</h3>
        <ul class="recent-list">
          ${data.recent.map(r => `<li>${r.query} (${r.created_at})</li>`).join('')}
        </ul>
      `;
    });
});
