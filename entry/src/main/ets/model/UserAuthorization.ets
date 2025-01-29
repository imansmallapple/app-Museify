export class UserAuthorizeAccepted {
  code: string
  state: string

  constructor(code: string, state: string) {
    this.code = code
    this.state = state
  }
}

export class UserAuthorizeDenied {
  error: string
  state: string

  constructor(error: string, state: string) {
    this.error = error
    this.state = state
  }
}

export class URLSearchParams {
  response_type: string
  client_id: string
  scope: string
  redirect_uri: string
  state: string

  constructor(response_type: string, client_id: string, scope: string, redirect_uri: string, state: string) {
    this.response_type = response_type
    this.client_id = client_id
    this.scope = scope
    this.redirect_uri = redirect_uri
    this.state = state
  }
}

export interface SpotifyTokenResponse {
  access_token: string;
  token_type: string;
  expires_in: number;
  scope?: string; // Optional if not always returned
  refresh_token?: string; // Optional if not always returned
  error?: string; // Optional if there might be an error field
}
