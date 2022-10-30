const fs = require('fs')
const sourceDir = __dirname + '/node_modules/mdi-material-ui'
const targetDir = __dirname + '/mdi-material-ui-inline'

try { fs.rmSync(targetDir, { recursive: true }) } catch { }
fs.mkdirSync(targetDir, { recursive: true })

const index = fs.readFileSync(sourceDir + '/index.es.js', 'utf8')
const regex = /export \{ default as ([^ ]+) \} from \'([^']+)\'/g
let output = ''
let match

output += `
import { createElement } from 'react'
import { createSvgIcon } from '@mui/material/utils'
function createIcon(path, name) {
  return createSvgIcon(createElement("path", { d: path }), name)
}
`

while (match = regex.exec(index)) {
  const source = fs.readFileSync(`${sourceDir}/${match[2]}.js`, 'utf8')
  const icon = /\(0, _createIcon\["default"\]\)\(('[^']+', '[^']+')\)/.exec(source);
  output += `export let ${match[1]} = /* @__PURE__ */ createIcon(${icon[1]})\n`
  fs.writeFileSync(`${targetDir}/${match[1]}.js`, `export { ${match[1]} as default } from './index'\n`)
}

fs.writeFileSync(targetDir + '/index.js', output)
