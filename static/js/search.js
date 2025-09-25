async function initSearch() {
  const res = await fetch('/index.json');
  const data = await res.json();

  const fuse = new Fuse(data, {
    keys: ['title', 'tags', 'categories', 'description'],
    threshold: 0.3,
    ignoreLocation: true
  });

  const input = document.getElementById('search');
  const results = document.getElementById('results');

  if (!input || !results) return;

  input.addEventListener('input', () => {
    const q = input.value.trim();
    if (!q) { 
      results.innerHTML = ''; 
      results.style.display = 'none';
      return; 
    }
    
    const hits = fuse.search(q).slice(0, 20);
    if (hits.length === 0) {
      results.innerHTML = '<li>No results found</li>';
    } else {
      results.innerHTML = hits.map(h =>
        `<li>
          <a href="${h.item.url}" class="search-result">
            ${h.item.featured_image ? `<img src="${h.item.featured_image}" alt="${h.item.title}" class="search-thumb">` : ''}
            <div class="search-content">
              <h4>${h.item.title}</h4>
              ${h.item.tags?.length ? `<div class="search-tags">${h.item.tags.join(', ')}</div>` : ''}
              <p>${h.item.description || ''}</p>
            </div>
          </a>
        </li>`
      ).join('');
    }
    results.style.display = 'block';
  });

  // Close search results when clicking outside
  document.addEventListener('click', (e) => {
    if (!input.contains(e.target) && !results.contains(e.target)) {
      results.style.display = 'none';
    }
  });
}

document.addEventListener('DOMContentLoaded', initSearch);