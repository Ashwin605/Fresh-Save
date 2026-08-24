const fs = require('fs');
const path = require('path');

function walkDir(dir, callback) {
    fs.readdirSync(dir).forEach(f => {
        let dirPath = path.join(dir, f);
        let isDirectory = fs.statSync(dirPath).isDirectory();
        isDirectory ? walkDir(dirPath, callback) : callback(path.join(dir, f));
    });
}

walkDir('lib', function(filePath) {
    if (filePath.endsWith('.dart')) {
        let content = fs.readFileSync(filePath, 'utf8');
        let newContent = content
            .replace(/const\s+Text\(\s*([^)]+style:\s*AppTypography\.[a-zA-Z]+)/g, 'Text(')
            .replace(/const\s+Text\(\n([^\)]+style:\s*AppTypography\.[a-zA-Z]+)/g, 'Text(\n')
            .replace(/const\s+AppBarTheme\(/g, 'AppBarTheme(')
            .replace(/const\s+TextTheme\(/g, 'TextTheme(')
            .replace(/children:\s*const\s*\[/g, 'children: [');
        if (content !== newContent) {
            fs.writeFileSync(filePath, newContent, 'utf8');
            console.log('Fixed:', filePath);
        }
    }
});
