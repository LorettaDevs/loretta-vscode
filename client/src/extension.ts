/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */

import { join } from 'path';
import { platform } from 'os';
import { chmodSync } from 'fs';
import { ExtensionContext } from 'vscode';

import {
  LanguageClient,
  LanguageClientOptions,
  ServerOptions
} from 'vscode-languageclient/node';

const binaryMap: Partial<Record<NodeJS.Platform, string>> = {
  'win32': 'loretta-lsp-win.exe',
  'linux': 'loretta-lsp-linux',
  'darwin': 'loretta-lsp-osx'
};

let client: LanguageClient;

export function activate(context: ExtensionContext) {

  const command: string = context.asAbsolutePath(
    join('server', 'bin', binaryMap[platform()])
  );
  if (platform() === 'linux' || platform() === 'darwin')
    chmodSync(command, '777');

  const serverOptions: ServerOptions = {
    command: command
  };

  const clientOptions: LanguageClientOptions = {
    documentSelector: [{ scheme: 'file', language: 'lua' }]
  };

  // Create the language client and start the client.
  client = new LanguageClient(
    'loretta',
    'Loretta',
    serverOptions,
    clientOptions
  );

  // Start the client. This will also launch the server
  client.start();
}

export function deactivate(): Thenable<void> | undefined {
  if (!client) {
    return undefined;
  }
  return client.stop();
}
