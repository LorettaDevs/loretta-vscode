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
  ServerOptions,
  Trace
} from 'vscode-languageclient/node';

const binaryMap: Partial<Record<NodeJS.Platform, string>> = {
  'win32': 'loretta-lsp-win.exe',
  'linux': 'loretta-lsp-linux',
  'darwin': 'loretta-lsp-osx'
};

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
  const client = new LanguageClient(
    'loretta',
    'Loretta',
    serverOptions,
    clientOptions
  );
  client.registerProposedFeatures();
  client.trace = Trace.Verbose;

  // Start the client. This will also launch the server
  let disposable = client.start();

  context.subscriptions.push(disposable);
}
