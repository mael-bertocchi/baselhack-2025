export interface SigninBody {
    email: string;
    password: string;
}

export interface SignupBody {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    confirmPassword: string;
}

export interface RefreshBody {
    refreshToken: string;
}

export interface AuthenticatedUser {
    id: string;
    email: string;
    payload: Record<string, unknown>;
}
