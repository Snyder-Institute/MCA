<?php include 'header.php'; ?>

<style>
/* ── Layout ─────────────────────────────────────────────────────────────────── */
.ps-wrap { max-width: 940px; margin: 0 auto; padding: 30px 16px 60px; }
.ps-wrap h1 { font-size: 26px; margin: 0 0 6px; }
.ps-subtitle { color: #555; font-size: 14px; margin: 0 0 24px; }

/* ── Search bar ─────────────────────────────────────────────────────────────── */
.ps-bar-wrap { position: relative; margin-bottom: 20px; }
.ps-bar-row  { display: flex; gap: 10px; }
.ps-input {
    flex: 1;
    font-size: 15px;
    padding: 11px 16px;
    border: 1.5px solid #d0d8f0;
    border-radius: 8px;
    outline: none;
    font-family: inherit;
    transition: border-color 0.15s;
}
.ps-input:focus { border-color: #404f7c; }
.ps-btn {
    padding: 11px 22px;
    background: #404f7c;
    color: #fff;
    border: none;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    font-family: inherit;
    transition: background 0.15s;
}
.ps-btn:hover { background: #2f3a5e; }

.ps-input-wrap { flex: 1; position: relative; display: flex; }
.ps-input { padding-right: 38px; }
.ps-clear {
    position: absolute;
    right: 10px;
    top: 50%;
    transform: translateY(-50%);
    width: 22px; height: 22px;
    border: none; border-radius: 50%;
    background: #d0d8f0; color: #fff;
    font-size: 16px; line-height: 1; font-weight: 700;
    cursor: pointer; padding: 0;
    display: none; align-items: center; justify-content: center;
    font-family: inherit;
    transition: background 0.15s;
}
.ps-clear:hover { background: #404f7c; }
.ps-clear.show { display: flex; }

.ps-btn-secondary {
    padding: 9px 22px;
    background: #fff; color: #404f7c;
    border: 1.5px solid #d0d8f0; border-radius: 8px;
    font-size: 13px; font-weight: 600;
    cursor: pointer; font-family: inherit;
    transition: all 0.15s;
}
.ps-btn-secondary:hover { background: #f0f4ff; border-color: #404f7c; }

/* ── Autocomplete ────────────────────────────────────────────────────────────── */
.ac-dropdown {
    position: absolute;
    top: 100%;
    left: 0;
    right: 60px;
    background: #fff;
    border: 1.5px solid #d0d8f0;
    border-radius: 8px;
    box-shadow: 0 4px 16px rgba(64,79,124,0.12);
    z-index: 100;
    max-height: 360px;
    overflow-y: auto;
    display: none;
}
.ac-group { font-size: 10px; font-weight: 800; letter-spacing: 0.08em; text-transform: uppercase;
    color: #888; padding: 10px 14px 4px; }
.ac-item {
    padding: 8px 14px; cursor: pointer; font-size: 13px;
    display: flex; align-items: baseline; gap: 8px; transition: background 0.1s;
}
.ac-item:hover { background: #f0f4ff; }
.ac-name { color: #222; font-weight: 500; flex: 1; }
.ac-meta { color: #888; font-size: 11px; white-space: nowrap; }
.ac-badge {
    font-size: 10px; font-weight: 700; padding: 1px 6px; border-radius: 4px; white-space: nowrap;
}
.ac-pathway { background: #dbeafe; color: #1e40af; }
.ac-taxon   { background: #d1fae5; color: #065f46; }
.ac-disease { background: #fce7f3; color: #9d174d; }

/* ── Results ────────────────────────────────────────────────────────────────── */
.ps-results { min-height: 80px; }
.ps-loading { color: #888; font-size: 14px; padding: 16px 0; }
.ps-empty   { color: #888; font-size: 14px; padding: 16px 0; }

.sec-label {
    font-family: "Montserrat", sans-serif;
    font-size: 11px; font-weight: 800; letter-spacing: 0.08em; text-transform: uppercase;
    color: #404f7c; border-bottom: 2px solid #404f7c;
    padding-bottom: 5px; margin: 24px 0 12px; display: inline-block;
}

/* ── Passport card ──────────────────────────────────────────────────────────── */
.pc {
    border: 1px solid #eee; border-radius: 8px; padding: 14px 16px;
    margin-bottom: 10px; background: #fff;
    transition: border-color 0.15s, box-shadow 0.15s; cursor: pointer;
}
.pc:hover { border-color: #cdd4f0; box-shadow: 0 2px 8px rgba(64,79,124,0.07); }
.pc-head { display: flex; align-items: baseline; gap: 10px; margin-bottom: 6px; flex-wrap: wrap; }
.pc-name { font-size: 15px; font-weight: 700; color: #222; text-decoration: none; }
.pc-name:hover { text-decoration: underline; }
.pc-rank { font-size: 12px; color: #888; }
.pb { font-size: 11px; font-weight: 700; padding: 2px 8px; border-radius: 4px; }
.pb-yes   { background: #007bff; color: #fff; }
.pb-other { background: #f3f4f6; color: #6b7280; }

.via-row { font-size: 12px; color: #555; margin-top: 4px; }
.via-lbl { color: #888; }
.chip { display: inline-block; font-size: 11px; padding: 2px 8px; border-radius: 4px; margin: 1px 2px; }
.chip-disease  { background: #fce7f3; color: #9d174d; border: 1px solid #f9a8d4; }
.chip-compound { background: #d1fae5; color: #065f46; border: 1px solid #6ee7b7; }
.chip-drug     { background: #ffedd5; color: #9a3412; border: 1px solid #fdba74; }

/* ── Pathway card ───────────────────────────────────────────────────────────── */
.pw-card {
    border: 1px solid #eee; border-radius: 8px; padding: 11px 16px; margin-bottom: 8px;
    background: #fff; cursor: pointer; display: flex; align-items: center; gap: 12px;
    transition: border-color 0.15s, box-shadow 0.15s;
}
.pw-card:hover { border-color: #cdd4f0; box-shadow: 0 2px 8px rgba(64,79,124,0.07); }
.pw-id   { font-size: 11px; font-family: monospace; color: #888; white-space: nowrap; }
.pw-name { font-size: 14px; font-weight: 600; color: #222; flex: 1; }
.pw-cat  { font-size: 11px; color: #888; white-space: nowrap; }
.pw-cnt  { font-size: 12px; font-weight: 700; background: #eef0f8; color: #404f7c;
    border: 1px solid #c8cde8; border-radius: 12px; padding: 2px 10px; white-space: nowrap; }

/* ── Co-occur chips ─────────────────────────────────────────────────────────── */
.cooc-grid { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 4px; }
.cooc-chip {
    font-size: 12px; padding: 5px 12px; border: 1px solid #eee; border-radius: 20px;
    background: #fff; cursor: pointer; transition: border-color 0.15s;
    display: flex; align-items: center; gap: 6px; text-decoration: none; color: #222;
}
.cooc-chip:hover { border-color: #404f7c; }
.cooc-n { font-size: 10px; color: #888; }

/* ── Browse table ───────────────────────────────────────────────────────────── */
.br-table { width: 100%; border-collapse: collapse; font-size: 13px; }
.br-table th {
    text-align: left; padding: 9px 12px; background: #f5f6fa; border-bottom: 2px solid #eee;
    font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; color: #555;
}
.br-table td { padding: 9px 12px; border-bottom: 1px solid #f0f0f0; vertical-align: top; }
.br-table tr:hover td { background: #fafafa; cursor: pointer; }
.br-cat td { background: #f5f6fa !important; font-weight: 700; color: #404f7c;
    font-size: 12px; padding: 6px 12px; cursor: default !important; }

/* ── Drug target card ───────────────────────────────────────────────────────── */
.dt-card {
    border: 1px solid #ffedd5; border-radius: 8px; padding: 10px 14px;
    margin-bottom: 8px; background: #fff; font-size: 13px;
}
.dt-name  { font-weight: 600; color: #222; }
.dt-class { color: #9a3412; font-size: 12px; margin-top: 2px; }

/* ── Info box ───────────────────────────────────────────────────────────────── */
.info-box {
    background: #f0f4ff; border: 1px solid #d0d8f0; border-radius: 8px;
    padding: 12px 16px; font-size: 13px; color: #404f7c; margin-bottom: 16px; line-height: 1.6;
}
</style>

<div class="ps-wrap">

    <div class="logo-container" style="margin-bottom: 20px;">
        <a href="index.php" id="ps-logo" style="display: inline-block;">
            <img src="./images/logo.png" class="logo-main" alt="MCA Logo" style="cursor: pointer;">
        </a>
    </div>

    <h1>Advanced Search</h1>
    <p class="ps-subtitle">
        Search MCA taxa by KEGG pathway, disease, or taxon name. &nbsp;
        <a href="search_help.php" style="color:#007bff;text-decoration:none;">Help &amp; query guide →</a>
    </p>

    <!-- Search bar -->
    <div class="ps-bar-wrap">
        <div class="ps-bar-row">
            <div class="ps-input-wrap">
                <input id="ps-input" class="ps-input" type="text" autocomplete="off"
                       placeholder="Search pathways, taxa, or diseases…">
                <button class="ps-clear" id="ps-clear" type="button" aria-label="Clear search">&times;</button>
            </div>
            <button class="ps-btn" onclick="triggerSearch()">Search</button>
            <button class="ps-btn-secondary" onclick="loadBrowse()">Browse all pathways</button>
        </div>
        <div class="ac-dropdown" id="ac-drop"></div>
    </div>

    <!-- Results -->
    <div class="ps-results" id="ps-results"></div>

</div>

<script>
var currentMode = 'pathway';
var acTimer = null;

// ── Autocomplete ────────────────────────────────────────────────────────────────

var inp      = document.getElementById('ps-input');
var drop     = document.getElementById('ac-drop');
var clearBtn = document.getElementById('ps-clear');
var logoLink = document.getElementById('ps-logo');

inp.addEventListener('input', function() {
    clearTimeout(acTimer);
    var q = inp.value.trim();
    clearBtn.classList.toggle('show', inp.value.length > 0);
    if (q.length < 2) { drop.style.display = 'none'; return; }
    acTimer = setTimeout(function() { fetchAC(q); }, 200);
});

inp.addEventListener('keydown', function(e) {
    if (e.key === 'Enter')  { drop.style.display = 'none'; triggerSearch(); }
    if (e.key === 'Escape') { drop.style.display = 'none'; resetToInitial(); }
});

clearBtn.addEventListener('click', resetToInitial);

logoLink.addEventListener('click', function(e) {
    e.preventDefault();
    resetToInitial();
});

document.addEventListener('click', function(e) {
    if (!e.target.closest('.ps-bar-wrap')) drop.style.display = 'none';
});

function fetchAC(q) {
    fetch('ajax_pathway.php?mode=autocomplete&q=' + encodeURIComponent(q) + '&limit=8')
        .then(function(r) { return r.json(); })
        .then(function(data) { renderAC(data, q); });
}

function renderAC(data, q) {
    var html = '';

    if (data.pathways && data.pathways.length) {
        html += '<div class="ac-group">Pathways</div>';
        data.pathways.forEach(function(p) {
            html += '<div class="ac-item" onclick="selectAC(\'pathway\',\'' + es(p.id) + '\',\'' + es(p.name) + '\')">' +
                '<span class="ac-badge ac-pathway">Pathway</span>' +
                '<span class="ac-name">' + hi(p.name, q) + '</span>' +
                '<span class="ac-meta">' + es(p.id) + ' · ' + p.taxon_count + ' taxa</span>' +
                '</div>';
        });
    }
    if (data.taxa && data.taxa.length) {
        html += '<div class="ac-group">Taxa</div>';
        data.taxa.forEach(function(t) {
            html += '<div class="ac-item" onclick="selectAC(\'taxon\',\'' + es(t.passport_id) + '\',\'' + es(t.name) + '\')">' +
                '<span class="ac-badge ac-taxon">Taxon</span>' +
                '<span class="ac-name">' + hi(t.name, q) + '</span>' +
                '<span class="ac-meta">' + es(t.passport_id) + (t.has_pathways ? '' : ' · no pathways') + '</span>' +
                '</div>';
        });
    }
    if (data.diseases && data.diseases.length) {
        html += '<div class="ac-group">Diseases</div>';
        data.diseases.forEach(function(d) {
            html += '<div class="ac-item" onclick="selectAC(\'disease\',\'' + es(d.id) + '\',\'' + es(d.name) + '\')">' +
                '<span class="ac-badge ac-disease">Disease</span>' +
                '<span class="ac-name">' + hi(d.name, q) + '</span>' +
                '<span class="ac-meta">' + es(d.id) + '</span>' +
                '</div>';
        });
    }

    if (!html) { drop.style.display = 'none'; return; }
    drop.innerHTML = html;
    drop.style.display = 'block';
}

function selectAC(type, id, name) {
    inp.value = name;
    drop.style.display = 'none';
    currentMode = type;
    loadResults(id);
}

// ── Search ──────────────────────────────────────────────────────────────────────

function triggerSearch() {
    var q = inp.value.trim();
    if (!q) { resetToInitial(); return; }

    // Direct ID detection
    if (/^hsa\d{5}$/i.test(q) || /^map\d{5}$/i.test(q) || /^nt\d+$/i.test(q)) {
        currentMode = 'pathway'; loadResults(q.toLowerCase()); return;
    }
    if (/^H\d{5}$/i.test(q)) { currentMode = 'disease'; loadResults(q.toUpperCase()); return; }
    if (/^MCA-/i.test(q))    { currentMode = 'taxon';   loadResults(q); return; }

    // Pick top match across all groups: disease > taxon > pathway
    fetch('ajax_pathway.php?mode=autocomplete&q=' + encodeURIComponent(q) + '&limit=1')
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.diseases && data.diseases.length) {
                currentMode = 'disease'; loadResults(data.diseases[0].id);
            } else if (data.taxa && data.taxa.length) {
                currentMode = 'taxon'; loadResults(data.taxa[0].passport_id);
            } else if (data.pathways && data.pathways.length) {
                currentMode = 'pathway'; loadResults(data.pathways[0].id);
            } else {
                setResults('<p class="ps-empty">No results found for "' + es(q) + '".</p>');
            }
        });
}

function loadResults(id) {
    setResults('<p class="ps-loading">Loading…</p>');
    fetch('ajax_pathway.php?mode=' + currentMode + '&id=' + encodeURIComponent(id))
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.error) { setResults('<p class="ps-empty">' + es(data.error) + '</p>'); return; }
            if (currentMode === 'pathway') renderPathway(data);
            else if (currentMode === 'taxon') renderTaxon(data);
            else if (currentMode === 'disease') renderDisease(data);
        })
        .catch(function() { setResults('<p class="ps-empty">Request failed.</p>'); });
}

function loadBrowse() {
    setResults('<p class="ps-loading">Loading pathway index…</p>');
    fetch('ajax_pathway.php?mode=browse')
        .then(function(r) { return r.json(); })
        .then(function(data) { renderBrowse(data); });
}

function setResults(html) { document.getElementById('ps-results').innerHTML = html; }

// ── Initial / reset state ──────────────────────────────────────────────────────

function showInitialState() {
    setResults('');
}

function resetToInitial() {
    inp.value = '';
    drop.style.display = 'none';
    clearBtn.classList.remove('show');
    showInitialState();
    inp.focus();
}

// ── Render helpers ─────────────────────────────────────────────────────────────

function passportCard(t) {
    var pbClass = t.is_pathobiont === 'yes' ? 'pb-yes' : 'pb-other';
    var pbLabel = t.is_pathobiont === 'yes' ? 'Pathobiont' : es(t.is_pathobiont);
    var via = '';
    if (t.via_diseases && t.via_diseases.length) {
        via += '<div class="via-row"><span class="via-lbl">Via disease: </span>' +
            t.via_diseases.map(function(d) {
                return '<span class="chip chip-disease" title="' + es(d.id) + '">' + es(d.label || d.id) + '</span>';
            }).join('') + '</div>';
    }
    if (t.via_compounds && t.via_compounds.length) {
        via += '<div class="via-row"><span class="via-lbl">Via compound: </span>' +
            t.via_compounds.map(function(c) {
                return '<span class="chip chip-compound">' + es(c.name || c.id) + '</span>';
            }).join('') + '</div>';
    }
    var roles = (t.roles && t.roles.length)
        ? '<div style="font-size:12px;color:#555;">' + t.roles.slice(0,3).map(es).join(' · ') + '</div>' : '';
    return '<div class="pc" onclick="window.location.href=\'' + es(t.passport_id) + '\'">' +
        '<div class="pc-head">' +
        '<a class="pc-name" href="' + es(t.passport_id) + '">' + es(t.name) + '</a>' +
        '<span class="pc-rank">' + es(t.taxon_rank) + '</span>' +
        '<span class="pb ' + pbClass + '">' + pbLabel + '</span>' +
        '<span style="font-family:monospace;font-size:11px;color:#888;margin-left:auto;">' + es(t.passport_id) + '</span>' +
        '</div>' + roles + via + '</div>';
}

function pathwayCard(p, linking, via_type) {
    var chips = '';
    if (linking && linking.length) {
        chips = '<div style="margin:-2px 0 6px 8px;">' +
            linking.map(function(l) {
                return '<span class="chip chip-' + via_type + '">' + es(l.label || l.name || l.id) + '</span>';
            }).join('') + '</div>';
    }
    return '<div class="pw-card" onclick="selectAC(\'pathway\',\'' + es(p.id) + '\',\'' + es(p.name) + '\')">' +
        '<span class="pw-id">' + es(p.id) + '</span>' +
        '<span class="pw-name">' + es(p.name) + '</span>' +
        '<span class="pw-cat">' + es(p.category) + '</span>' +
        '<span class="pw-cnt">' + p.taxon_count + ' taxa</span>' +
        '</div>' + chips;
}

// ── Render: Q3 — Pathway → Taxa ────────────────────────────────────────────────

function renderPathway(data) {
    var p = data.pathway;
    var html = '<div style="margin-bottom:16px;">' +
        '<div style="font-size:18px;font-weight:700;color:#222;">' + es(p.name) + '</div>' +
        '<div style="font-size:12px;color:#888;margin-top:2px;">' + es(p.id) +
        (p.category ? ' &nbsp;·&nbsp; ' + es(p.category) : '') +
        (p.subcategory ? ' › ' + es(p.subcategory) : '') + '</div></div>';

    if (!data.taxa || !data.taxa.length) {
        html += '<p class="ps-empty">No MCA taxa linked to this pathway.</p>';
    } else {
        html += '<div class="sec-label">Linked Taxa (' + data.taxa.length + ')</div>';
        data.taxa.forEach(function(t) { html += passportCard(t); });
    }

    if (data.related_diseases && data.related_diseases.length) {
        html += '<div class="sec-label" style="margin-top:28px;">All Diseases in This Pathway (' + data.related_diseases.length + ')</div>';
        html += '<div style="display:flex;flex-wrap:wrap;gap:6px;">';
        data.related_diseases.forEach(function(d) {
            html += '<span class="chip chip-disease" style="cursor:pointer;padding:4px 10px;" ' +
                'onclick="selectAC(\'disease\',\'' + es(d.id) + '\',\'' + es(d.name) + '\')">' +
                es(d.name) + ' <span style="opacity:.6;">' + es(d.id) + '</span></span>';
        });
        html += '</div>';
    }

    setResults(html);
}

// ── Render: Q1 + Q2 + Q6 — Taxon → Pathways + Co-occurring Taxa ───────────────

function renderTaxon(data) {
    var html = '<div style="margin-bottom:16px;">' +
        '<div style="font-size:18px;font-weight:700;color:#222;">' +
        '<a href="' + es(data.passport_id) + '" style="color:#222;text-decoration:none;">' +
        es(data.name) + '</a></div>' +
        '<div style="font-size:12px;color:#888;margin-top:2px;">' + es(data.passport_id) +
        ' &nbsp;·&nbsp; ' + data.total_pathways + ' pathway' + (data.total_pathways !== 1 ? 's' : '') + ' linked</div></div>';

    if (data.total_pathways === 0) {
        html += '<div class="info-box">No KEGG pathway links found for this taxon. This indicates that the passport does not yet have KEGG Disease, Drug, or Compound IDs annotated.</div>';
    }

    // Pathways linked via clinical-association diseases
    if (data.pathways.via_diseases && data.pathways.via_diseases.length) {
        html += '<div class="sec-label">Pathways via Disease Associations</div>';
        data.pathways.via_diseases.forEach(function(p) {
            html += pathwayCard(p, p.linking_diseases, 'disease');
        });
    }

    // Pathways linked via metabolite compounds
    if (data.pathways.via_compounds && data.pathways.via_compounds.length) {
        html += '<div class="sec-label">Pathways via Metabolites</div>';
        data.pathways.via_compounds.forEach(function(p) {
            html += pathwayCard(p, p.linking_compounds, 'compound');
        });
    }

    // Drug target classes
    if (data.drug_classes && data.drug_classes.length) {
        html += '<div class="sec-label">Drug Target Classes (Bloom Triggers)</div>';
        data.drug_classes.forEach(function(d) {
            html += '<div class="dt-card"><div class="dt-name">' + es(d.name) +
                ' <span style="font-size:11px;color:#888;">' + es(d.id) + '</span></div>' +
                '<div class="dt-class">' + es(d.target_class) +
                (d.target_family ? ' › ' + es(d.target_family) : '') + '</div></div>';
        });
    }

    // Co-occurring taxa via shared pathways
    if (data.cooccurring && data.cooccurring.length) {
        html += '<div class="sec-label">Co-occurring Taxa via Shared Pathways</div>';
        html += '<div class="cooc-grid">';
        data.cooccurring.forEach(function(t) {
            var pbClass = t.is_pathobiont === 'yes' ? 'pb-yes' : 'pb-other';
            html += '<span class="cooc-chip" onclick="selectAC(\'taxon\',\'' + es(t.passport_id) + '\',\'' + es(t.name) + '\')">' +
                '<span class="pb ' + pbClass + '" style="font-size:10px;">' + es(t.is_pathobiont) + '</span>' +
                '<span>' + es(t.name) + '</span>' +
                '<span class="cooc-n">' + t.shared_pathways + ' shared</span>' +
                '</span>';
        });
        html += '</div>';
    }

    setResults(html);
}

// ── Render: Q4 — Disease → Passports + Pathways ────────────────────────────────

function renderDisease(data) {
    var d = data.disease;
    var html = '<div style="margin-bottom:16px;">' +
        '<div style="font-size:18px;font-weight:700;color:#222;">' + es(d.name) + '</div>' +
        '<div style="font-size:12px;color:#888;margin-top:2px;">' + es(d.id) +
        (data.inf_class
            ? ' &nbsp;·&nbsp; ' + es(data.inf_class.category) + ' › ' + es(data.inf_class.subcategory)
            : '') + '</div></div>';

    if (data.pathways && data.pathways.length) {
        html += '<div class="sec-label">KEGG Pathways for This Disease (' + data.pathways.length + ')</div>';
        data.pathways.forEach(function(p) {
            html += '<div class="pw-card" onclick="selectAC(\'pathway\',\'' + es(p.id) + '\',\'' + es(p.name) + '\')">' +
                '<span class="pw-id">' + es(p.id) + '</span>' +
                '<span class="pw-name">' + es(p.name) + '</span>' +
                '<span class="pw-cat">' + es(p.category) + '</span>' +
                '<span class="pw-cnt">' + p.taxon_count + ' taxa</span></div>';
        });
    } else {
        html += '<div class="info-box">No KEGG pathway annotations found for this disease in the local KEGG flat file.</div>';
    }

    if (data.taxa && data.taxa.length) {
        html += '<div class="sec-label">MCA Taxa Associated with This Disease (' + data.taxa.length + ')</div>';
        data.taxa.forEach(function(t) { html += passportCard(t); });
    } else {
        html += '<div class="info-box">No MCA passports directly reference this KEGG Disease ID in their clinical associations.</div>';
    }

    setResults(html);
}

// ── Render: Q5 — Browse Pathways ───────────────────────────────────────────────

function renderBrowse(data) {
    var rows = data.pathways || [];
    if (!rows.length) { setResults('<p class="ps-empty">No pathways found.</p>'); return; }

    var html = '<div class="sec-label">All Pathways Linked to MCA Taxa (' + rows.length + ')</div>' +
        '<table class="br-table"><thead><tr>' +
        '<th>Category</th><th>Pathway</th><th style="text-align:right">Taxa</th>' +
        '</tr></thead><tbody>';

    rows.forEach(function(p) {
        html += '<tr onclick="selectAC(\'pathway\',\'' + es(p.id) + '\',\'' + es(p.name) + '\')">' +
            '<td style="color:#555;white-space:nowrap;">' + es(p.category) + '</td>' +
            '<td><div style="font-weight:600;color:#222;">' + es(p.name) + '</div>' +
            '<div style="font-size:11px;color:#888;margin-top:1px;">' + es(p.id) +
            (p.subcategory ? ' · ' + es(p.subcategory) : '') + '</div></td>' +
            '<td style="text-align:right;"><span class="pw-cnt">' + p.taxon_count + '</span></td></tr>';
    });

    html += '</tbody></table>';
    setResults(html);
}

// ── Utilities ───────────────────────────────────────────────────────────────────

function es(s) {
    if (s === null || s === undefined) return '';
    return String(s)
        .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
        .replace(/"/g,'&quot;').replace(/'/g,'&#39;');
}

function hi(text, q) {
    var safe = es(text);
    var re = new RegExp('(' + q.replace(/[.*+?^${}()|[\]\\]/g,'\\$&') + ')', 'gi');
    return safe.replace(re, '<strong>$1</strong>');
}

// ── Init: show clean intro; Browse only on explicit request ──────────────────
showInitialState();
</script>

<?php include 'footer.php'; ?>
