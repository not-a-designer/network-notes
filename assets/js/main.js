// Progressive enhancement: reading and navigation work without JavaScript.
document.querySelectorAll('.prose table').forEach((table) => {
  const region = document.createElement('div');
  region.className = 'table-scroll';
  region.tabIndex = 0;
  region.setAttribute('role', 'region');
  region.setAttribute('aria-label', 'Scrollable table');
  table.before(region);
  region.append(table);
});
document.querySelectorAll('.prose pre').forEach((pre) => {
  pre.tabIndex = 0;
  pre.setAttribute('aria-label', 'Code block');
});
document.querySelectorAll('.prose img').forEach((img) => {
  if (!img.closest('a')) {
    const link = document.createElement('a');
    link.href = img.src;
    link.setAttribute('aria-label', `Open full-size image: ${img.alt || 'Diagram'}`);
    img.before(link);
    link.append(img);
  }
});
