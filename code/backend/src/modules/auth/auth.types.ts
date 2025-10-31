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
    accessToken: string;
    refreshToken: string;
}
