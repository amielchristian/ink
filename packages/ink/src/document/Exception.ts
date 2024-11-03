import type FileSystem from '@stackpress/types/dist/filesystem/FileSystem';

import path from 'path';
import NodeFS from '@stackpress/types/dist/filesystem/NodeFS';
import InkException from '../Exception';

/**
 * Exceptions are used to give more information
 * of an error that has occured
 */
export default class DocumentException extends InkException {
  //source code
  protected _source = '';
  //filesystem
  protected _fs: FileSystem = new NodeFS();

  /**
   * Return a new trace with source code snippet
   */
  public trace(start = 0, end = 0) {
    return super.trace(start, end).map(trace => {
      const { file } = trace;
      if (trace.method !== 'evalmachine.<anonymous>') {
        return { ...trace, source: this._source };
      } else if (file.startsWith(path.sep) 
        && this._fs.existsSync(file)
      ) {
        const source = this._fs.readFileSync(file, 'utf8');
        return { ...trace, source };
      }
      return { ...trace, source: '' };
    });
  }

  /**
   * Set the filesystem
   */
  public withFS(fs: FileSystem) {
    this._fs = fs;
    return this;
  }

  /**
   * Set the source code
   */
  public withSource(source: string) {
    this._source = source;
    return this;
  }
}
