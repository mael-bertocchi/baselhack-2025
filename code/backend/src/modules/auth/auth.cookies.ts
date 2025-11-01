import environment from '@core/environment';
import { FastifyReply } from 'fastify';

interface CookieOptions {
    httpOnly?: boolean;
    secure?: boolean;
    sameSite?: 'Strict' | 'Lax' | 'None';
    path?: string;
    maxAge?: number;
    domain?: string;
}

function parseDurationToSeconds(duration: string): number | undefined {
    const normalized = duration.trim().toLowerCase();

    if (/^\d+$/.test(normalized)) {
        return Number(normalized);
    }

    const match = normalized.match(/^(\d+)([smhd])$/);

    if (!match) {
        return undefined;
    }

    const value = Number(match[1]);
    const unit = match[2];

    switch (unit) {
        case 's':
            return value;
        case 'm':
            return value * 60;
        case 'h':
            return value * 60 * 60;
        case 'd':
            return value * 60 * 60 * 24;
        default:
            return undefined;
    }
}

function serializeCookie(name: string, value: string, options: CookieOptions = {}): string {
    const encodedValue = encodeURIComponent(value);
    let cookieString = `${name}=${encodedValue}`;

    cookieString += `; Path=${options.path ?? '/'}`;

    if (options.maxAge !== undefined) {
        cookieString += `; Max-Age=${Math.floor(options.maxAge)}`;

        const expires = new Date(Date.now() + Math.floor(options.maxAge) * 1000);
        cookieString += `; Expires=${expires.toUTCString()}`;
    }

    if (options.httpOnly) {
        cookieString += '; HttpOnly';
    }

    if (options.secure) {
        cookieString += '; Secure';
    }

    if (options.sameSite) {
        cookieString += `; SameSite=${options.sameSite}`;
    }

    if (options.domain) {
        cookieString += `; Domain=${options.domain}`;
    }

    return cookieString;
}

export function setAuthCookies(reply: FastifyReply, accessToken: string, refreshToken: string): void {
    const accessMaxAge = parseDurationToSeconds(environment.JWT_ACCESS_EXPIRES_IN);
    const refreshMaxAge = parseDurationToSeconds(environment.JWT_REFRESH_EXPIRES_IN);
    const sameSite = environment.COOKIE_SAME_SITE;
    const secure = environment.COOKIE_SECURE;
    const domain = environment.COOKIE_DOMAIN;

    const baseOptions: CookieOptions = {
        httpOnly: true,
        path: '/',
        secure,
        sameSite,
        domain
    };

    const accessCookie = serializeCookie('accessToken', accessToken, {
        ...baseOptions,
        maxAge: accessMaxAge
    });

    const refreshCookie = serializeCookie('refreshToken', refreshToken, {
        ...baseOptions,
        maxAge: refreshMaxAge
    });

    reply.header('Set-Cookie', [accessCookie, refreshCookie]);
}

function parseCookieHeader(cookieHeader?: string): Record<string, string> {
    if (!cookieHeader) {
        return {};
    }

    return cookieHeader.split(';').reduce<Record<string, string>>((cookies, fragment) => {
        const [rawName, ...rawValueParts] = fragment.split('=');
        const name = rawName?.trim();

        if (!name) {
            return cookies;
        }

        const value = rawValueParts.join('=').trim();
        cookies[name] = decodeURIComponent(value);
        return cookies;
    }, {});
}

export interface AuthCookies {
    accessToken?: string;
    refreshToken?: string;
}

export function extractAuthCookies(cookieHeader?: string): AuthCookies {
    const cookies = parseCookieHeader(cookieHeader);

    return {
        accessToken: cookies.accessToken,
        refreshToken: cookies.refreshToken
    };
}
