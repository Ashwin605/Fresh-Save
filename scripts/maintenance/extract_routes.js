const fs = require('fs');
const path = require('path');

function findControllers(dir, fileList = []) {
  const files = fs.readdirSync(dir);
  for (const file of files) {
    const fullPath = path.join(dir, file);
    if (fs.statSync(fullPath).isDirectory()) {
      findControllers(fullPath, fileList);
    } else if (file.endsWith('.controller.ts')) {
      fileList.push(fullPath);
    }
  }
  return fileList;
}

const controllers = findControllers(path.join(__dirname, 'src'));
const apiList = [];

for (const file of controllers) {
  const content = fs.readFileSync(file, 'utf8');
  const lines = content.split('\n');
  
  let baseRoute = '';
  let currentRoles = [];
  
  const controllerMatch = content.match(/@Controller\(['"]([^'"]+)['"]\)/);
  if (controllerMatch) {
    baseRoute = controllerMatch[1];
  }
  
  const globalRolesMatch = content.match(/@Roles\(([^)]+)\)/);
  if (globalRolesMatch) {
    currentRoles = globalRolesMatch[1].split(',').map(s => s.trim().replace(/UserRole\./g, ''));
  }

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const methodMatch = line.match(/@(Get|Post|Put|Patch|Delete)\(['"]([^'"]*)['"]\)?/);
    if (methodMatch) {
      const httpMethod = methodMatch[1].toUpperCase();
      const routePath = methodMatch[2];
      const fullPath = `/${baseRoute}${routePath ? '/' + routePath : ''}`.replace(/\/+/g, '/');
      
      let handler = 'unknown';
      for (let j = i + 1; j < Math.min(i + 10, lines.length); j++) {
        const handlerMatch = lines[j].match(/async ([a-zA-Z0-9_]+)\(/) || lines[j].match(/([a-zA-Z0-9_]+)\(/);
        if (handlerMatch && !lines[j].includes('@')) {
          handler = handlerMatch[1];
          break;
        }
      }
      
      apiList.push({
        method: httpMethod,
        endpoint: fullPath,
        file: path.basename(file),
        handler: handler,
        roles: currentRoles.join(', ') || 'Any'
      });
    }
  }
}

fs.writeFileSync('api_inventory.json', JSON.stringify(apiList, null, 2));
console.log('Extracted ' + apiList.length + ' endpoints.');
