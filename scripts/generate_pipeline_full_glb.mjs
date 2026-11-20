/**
 * pipeline.glb — CI/CD 수평 흐름 구조 (레퍼런스 기반)
 * 가로 보라 백본 라인 + 수직 스텁으로 연결된 아이콘 Stage + 라인 위 흐름 노드 점.
 * 앞/뒤 그룹을 얇은 프레임으로 묶는다. 연결선(pipe__*)은 Node(node__*)와 완전 분리.
 *
 * cd scripts && npm i three@0.169.0 && node generate_pipeline_full_glb.mjs
 */
import fs from 'node:fs';
import path from 'node:path';
import { Blob } from 'node:buffer';
import { fileURLToPath } from 'node:url';

globalThis.Blob = Blob;
globalThis.FileReader = class FileReader {
  result = null;
  onloadend = null;
  onerror = null;
  readAsArrayBuffer(blob) {
    Promise.resolve(blob.arrayBuffer())
      .then((buf) => {
        this.result = buf;
        this.onloadend?.({ target: this });
      })
      .catch((e) => this.onerror?.(e));
  }
};

import * as THREE from 'three';
import { GLTFExporter } from 'three/examples/jsm/exporters/GLTFExporter.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const outDir = path.join(__dirname, '..', 'assets', 'glb', 'pipeline');
fs.mkdirSync(outDir, { recursive: true });

// 흐름 순서(좌→우). 도메인 Stage id 유지.
const stages = [
  { id: 'collect', nodes: ['collect.field', 'collect.capture'] },
  { id: 'receive', nodes: ['receive.started', 'receive.screened', 'receive.done'] },
  {
    id: 'register',
    nodes: ['register.stored', 'register.asset', 'register.attached', 'register.duplicates'],
  },
  {
    id: 'postprocess',
    nodes: [
      'postprocess.run',
      'postprocess.props',
      'postprocess.duration',
      'postprocess.report',
      'postprocess.normalize',
      'postprocess.waveform',
      'postprocess.placed',
    ],
  },
  { id: 'tool', nodes: ['tool.run'] },
  { id: 'embed', nodes: ['embed.done'] },
  { id: 'done', nodes: ['done.searchable', 'done.stored'] },
];

const COL = {
  line: 0x5b2bb0, // 백본 보라
  lineSoft: 0x7a4fd0,
  dot: 0xf5922e, // 흐름 점 주황
  dotPurple: 0x6c33c4,
  ink: 0x3a1d6e,
  panel: 0x5a2db5,
  soft: 0xb7a9e0,
  teal: 0x2ec4b6,
  green: 0x3ddc84,
  cyan: 0x38bdf8,
  amber: 0xf5a623,
  frame: 0x9a86c8,
};

// Stage 상태 아이콘 기본색(흐름 상태 JS가 발광을 덮어씀)
const STAGE_COL = {
  collect: COL.panel,
  receive: COL.panel,
  register: COL.teal,
  postprocess: COL.amber,
  tool: COL.soft,
  embed: COL.cyan,
  done: COL.green,
};

const LINE_Y = 0.55;

function key(id) {
  return id.replace(/\./g, '_');
}

function emissiveMat(hex, name, ei = 0.6) {
  const m = new THREE.MeshStandardMaterial({
    color: hex,
    metalness: 0.2,
    roughness: 0.35,
    emissive: hex,
    emissiveIntensity: ei,
  });
  m.name = name;
  return m;
}

function bodyMat(hex, name, opts = {}) {
  const m = new THREE.MeshStandardMaterial({
    color: hex,
    metalness: opts.metalness ?? 0.35,
    roughness: opts.roughness ?? 0.5,
    emissive: opts.emissive ?? 0x000000,
    emissiveIntensity: opts.emissiveIntensity ?? 0.2,
  });
  m.name = name;
  return m;
}

/** 직선 튜브 세그먼트 (하나의 재질) */
function addTube(root, a, b, name, matName, color, radius, ei = 0.75) {
  const dir = b.clone().sub(a);
  const len = dir.length();
  const mesh = new THREE.Mesh(
    new THREE.CylinderGeometry(radius, radius, len, 10),
    emissiveMat(color, matName, ei),
  );
  mesh.position.copy(a.clone().lerp(b, 0.5));
  mesh.quaternion.setFromUnitVectors(new THREE.Vector3(0, 1, 0), dir.normalize());
  mesh.name = name;
  root.add(mesh);
}

/** 얇은 사각 프레임(장식, 상태 미연동) */
function addFrame(root, x0, x1, y0, y1, z, matName) {
  const mat = bodyMat(COL.frame, matName, { emissive: COL.frame, emissiveIntensity: 0.18 });
  const bars = [
    [(x0 + x1) / 2, y1, (x1 - x0), 0.03], // top
    [(x0 + x1) / 2, y0, (x1 - x0), 0.03], // bottom
    [x0, (y0 + y1) / 2, 0.03, (y1 - y0)], // left
    [x1, (y0 + y1) / 2, 0.03, (y1 - y0)], // right
  ];
  const g = new THREE.Group();
  g.name = matName.replace('mat__', '');
  bars.forEach(([cx, cy, w, h]) => {
    const bar = new THREE.Mesh(new THREE.BoxGeometry(w, h, 0.03), mat);
    bar.position.set(cx, cy, z);
    g.add(bar);
  });
  root.add(g);
}

// —— 아이콘 빌더 (XY 평면, +Z 향, 원점 중심) ——
function buildCode(statusMat) {
  const g = new THREE.Group();
  const panel = new THREE.Mesh(new THREE.BoxGeometry(0.95, 0.72, 0.14), statusMat);
  g.add(panel);
  const p1 = new THREE.Mesh(new THREE.BoxGeometry(0.1, 0.04, 0.03), emissiveMat(0xffffff, 'mat__collect_g1', 0.5));
  p1.position.set(-0.22, 0.02, 0.09);
  p1.rotation.z = -0.6;
  g.add(p1);
  const p2 = new THREE.Mesh(new THREE.BoxGeometry(0.1, 0.04, 0.03), emissiveMat(0xffffff, 'mat__collect_g2', 0.5));
  p2.position.set(-0.15, -0.06, 0.09);
  p2.rotation.z = 0.6;
  g.add(p2);
  const under = new THREE.Mesh(new THREE.BoxGeometry(0.22, 0.04, 0.03), emissiveMat(0xffffff, 'mat__collect_g3', 0.5));
  under.position.set(0.12, -0.12, 0.09);
  g.add(under);
  return g;
}

function buildCommit(statusMat) {
  const g = new THREE.Group();
  const ring = new THREE.Mesh(new THREE.TorusGeometry(0.34, 0.05, 12, 28), statusMat);
  g.add(ring);
  const hub = new THREE.Mesh(new THREE.SphereGeometry(0.12, 14, 12), emissiveMat(COL.panel, 'mat__receive_hub', 0.5));
  g.add(hub);
  const l = new THREE.Mesh(new THREE.CylinderGeometry(0.03, 0.03, 0.18, 8), emissiveMat(COL.panel, 'mat__receive_l', 0.4));
  l.rotation.z = Math.PI / 2;
  l.position.x = -0.42;
  g.add(l);
  const r = new THREE.Mesh(new THREE.CylinderGeometry(0.03, 0.03, 0.18, 8), emissiveMat(COL.panel, 'mat__receive_r', 0.4));
  r.rotation.z = Math.PI / 2;
  r.position.x = 0.42;
  g.add(r);
  return g;
}

function buildDb(statusMat) {
  const g = new THREE.Group();
  for (let i = 0; i < 3; i++) {
    const disk = new THREE.Mesh(
      new THREE.CylinderGeometry(0.4, 0.4, 0.22, 24),
      i === 1 ? statusMat : bodyMat(COL.teal, `mat__register_disk_${i}`, { emissive: COL.teal, emissiveIntensity: 0.25 }),
    );
    disk.position.y = i * 0.26 - 0.26;
    g.add(disk);
  }
  return g;
}

function buildTest(statusMat) {
  const g = new THREE.Group();
  const tube = new THREE.Mesh(new THREE.CylinderGeometry(0.17, 0.17, 0.7, 16), statusMat);
  g.add(tube);
  const bottom = new THREE.Mesh(new THREE.SphereGeometry(0.17, 16, 12, 0, Math.PI * 2, Math.PI / 2, Math.PI / 2), statusMat);
  bottom.position.y = -0.35;
  g.add(bottom);
  const cap = new THREE.Mesh(new THREE.CylinderGeometry(0.2, 0.2, 0.1, 16), emissiveMat(COL.amber, 'mat__postprocess_cap', 0.5));
  cap.position.y = 0.4;
  g.add(cap);
  for (let i = 0; i < 2; i++) {
    const bub = new THREE.Mesh(new THREE.SphereGeometry(0.05, 10, 8), emissiveMat(0xffd27f, `mat__postprocess_bub_${i}`, 0.6));
    bub.position.set(0.03 * (i ? 1 : -1), -0.1 + i * 0.12, 0.1);
    g.add(bub);
  }
  return g;
}

function buildTool(statusMat) {
  const g = new THREE.Group();
  const handle = new THREE.Mesh(new THREE.CylinderGeometry(0.06, 0.06, 0.55, 10), bodyMat(COL.ink, 'mat__tool_handle'));
  handle.rotation.z = Math.PI / 3;
  g.add(handle);
  const head = new THREE.Mesh(new THREE.TorusGeometry(0.16, 0.06, 10, 18, Math.PI * 1.4), statusMat);
  head.position.set(0.17, 0.3, 0);
  head.rotation.z = Math.PI / 2;
  g.add(head);
  return g;
}

function buildReview(statusMat) {
  const g = new THREE.Group();
  const ring = new THREE.Mesh(new THREE.TorusGeometry(0.3, 0.05, 12, 26), statusMat);
  g.add(ring);
  const handle = new THREE.Mesh(new THREE.CylinderGeometry(0.045, 0.045, 0.3, 8), emissiveMat(COL.cyan, 'mat__embed_handle', 0.45));
  handle.position.set(0.28, -0.28, 0);
  handle.rotation.z = Math.PI / 4;
  g.add(handle);
  const lt = new THREE.Mesh(new THREE.BoxGeometry(0.12, 0.035, 0.03), emissiveMat(0xffffff, 'mat__embed_c1', 0.5));
  lt.position.set(-0.1, 0.03, 0.08);
  lt.rotation.z = 0.7;
  g.add(lt);
  const rt = new THREE.Mesh(new THREE.BoxGeometry(0.12, 0.035, 0.03), emissiveMat(0xffffff, 'mat__embed_c2', 0.5));
  rt.position.set(0.1, 0.03, 0.08);
  rt.rotation.z = -0.7;
  g.add(rt);
  return g;
}

function buildRocket(statusMat) {
  const g = new THREE.Group();
  const body = new THREE.Mesh(new THREE.CapsuleGeometry(0.16, 0.42, 6, 14), statusMat);
  body.rotation.z = -Math.PI / 4;
  g.add(body);
  const nose = new THREE.Mesh(new THREE.ConeGeometry(0.16, 0.26, 16), emissiveMat(COL.cyan, 'mat__done_nose', 0.5));
  nose.position.set(0.28, 0.28, 0);
  nose.rotation.z = -Math.PI / 4;
  g.add(nose);
  const flame = new THREE.Mesh(new THREE.ConeGeometry(0.1, 0.3, 12), emissiveMat(COL.amber, 'mat__done_flame', 0.8));
  flame.position.set(-0.3, -0.3, 0);
  flame.rotation.z = (3 * Math.PI) / 4;
  g.add(flame);
  return g;
}

const builders = {
  collect: buildCode,
  receive: buildCommit,
  register: buildDb,
  postprocess: buildTest,
  tool: buildTool,
  embed: buildReview,
  done: buildRocket,
};

const root = new THREE.Group();
root.name = 'pipeline_root';

// 미세 배경 패널(어두운 받침)
const backdrop = new THREE.Mesh(
  new THREE.BoxGeometry(17, 7.5, 0.1),
  bodyMat(0x11131a, 'mat__backdrop', { metalness: 0.0, roughness: 1.0, emissive: 0x0b0e15, emissiveIntensity: 0.1 }),
);
backdrop.name = 'backdrop';
backdrop.position.set(0, 1.4, -0.9);
root.add(backdrop);

// Stage x 좌표(좌→우)
const n = stages.length;
const X0 = -6.3;
const X1 = 6.3;
const xs = stages.map((_, i) => X0 + ((X1 - X0) * i) / (n - 1));
const ICON_Y = 2.4;

// 백본 세그먼트 (상태 연동) : pipe__main_0..5
for (let i = 0; i < n - 1; i++) {
  addTube(
    root,
    new THREE.Vector3(xs[i], LINE_Y, 0),
    new THREE.Vector3(xs[i + 1], LINE_Y, 0),
    `pipe__main_${i}`,
    `mat__pipe__main_${i}`,
    COL.line,
    0.07,
    0.7,
  );
}
// 좌우 끝단 리드(장식, 상태 미연동)
addTube(root, new THREE.Vector3(X0 - 0.6, LINE_Y, 0), new THREE.Vector3(X0, LINE_Y, 0), 'lead_in', 'mat__lead_in', COL.line, 0.07, 0.4);
addTube(root, new THREE.Vector3(X1, LINE_Y, 0), new THREE.Vector3(X1 + 0.6, LINE_Y, 0), 'lead_out', 'mat__lead_out', COL.line, 0.07, 0.4);

// 각 Stage: 아이콘 + 수직 스텁 branch + 라인 위 노드 점 + 로컬 연결
stages.forEach((stage, si) => {
  const x = xs[si];
  const iconY = ICON_Y + (si % 2 === 0 ? 0.25 : -0.15); // 위아래 리듬

  const statusMat = emissiveMat(STAGE_COL[stage.id], `mat__stage_${stage.id}`, 0.5);
  const icon = builders[stage.id](statusMat);
  icon.name = `stage__${stage.id}`;
  icon.position.set(x, iconY, 0);
  root.add(icon);

  // 수직 스텁: 라인 → 아이콘 밑 : pipe__branch_{stage}
  addTube(
    root,
    new THREE.Vector3(x, LINE_Y, 0),
    new THREE.Vector3(x, iconY - 0.5, 0),
    `pipe__branch_${stage.id}`,
    `mat__pipe__branch_${stage.id}`,
    STAGE_COL[stage.id],
    0.04,
    0.7,
  );

  // 라인 위 흐름 노드 점
  const half = (xs[1] - xs[0]) * 0.34;
  const positions = [];
  stage.nodes.forEach((nodeId, ni) => {
    const k = key(nodeId);
    const t = stage.nodes.length === 1 ? 0 : ni / (stage.nodes.length - 1) - 0.5;
    const nx = x + t * 2 * half;
    const p = new THREE.Vector3(nx, LINE_Y, 0);
    positions.push(p);
    const bead = new THREE.Mesh(
      new THREE.SphereGeometry(0.11, 14, 12),
      emissiveMat(ni % 2 === 0 ? COL.dot : COL.dotPurple, `mat__${k}`, 0.5),
    );
    bead.name = `node__${k}`;
    bead.position.copy(p);
    root.add(bead);
  });

  // 로컬 연결(노드 점 사이) : pipe__local_{stage}_{i}
  for (let i = 0; i < positions.length - 1; i++) {
    addTube(
      root,
      positions[i],
      positions[i + 1],
      `pipe__local_${stage.id}_${i}`,
      `mat__pipe__local_${stage.id}_${i}`,
      STAGE_COL[stage.id],
      0.035,
      0.55,
    );
  }
});

// CI / CD 그룹 프레임(장식)
const ciMid = (xs[3] + xs[4]) / 2;
addFrame(root, X0 - 0.3, ciMid - 0.15, -0.25, 3.3, -0.4, 'mat__frame_ci');
addFrame(root, ciMid + 0.15, X1 + 0.3, -0.25, 3.3, -0.4, 'mat__frame_cd');

// idle 애니메이션(가벼운 부유)
root.animations = [
  new THREE.AnimationClip('idle', 2, [
    new THREE.VectorKeyframeTrack(
      'stage__done.position',
      [0, 1, 2],
      [
        xs[6], ICON_Y + 0.25, 0,
        xs[6], ICON_Y + 0.45, 0,
        xs[6], ICON_Y + 0.25, 0,
      ],
    ),
    new THREE.VectorKeyframeTrack(
      'stage__register.position',
      [0, 1, 2],
      [
        xs[2], ICON_Y + 0.25, 0,
        xs[2], ICON_Y + 0.35, 0,
        xs[2], ICON_Y + 0.25, 0,
      ],
    ),
  ]),
];

function exportGlb(object) {
  return new Promise((resolve, reject) => {
    const exporter = new GLTFExporter();
    exporter.parse(
      object,
      (result) => {
        if (result instanceof ArrayBuffer) resolve(Buffer.from(result));
        else reject(new Error('Expected binary GLB'));
      },
      (err) => reject(err),
      { binary: true, animations: object.animations },
    );
  });
}

root.updateMatrixWorld(true);
const buf = await exportGlb(root);
const file = path.join(outDir, 'pipeline.glb');
fs.writeFileSync(file, buf);
console.log('wrote', file, buf.length, 'bytes');
