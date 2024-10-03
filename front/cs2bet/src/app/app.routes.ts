import { Routes } from '@angular/router';
import { LoginComponent } from './login/login.component';
import { DisputeComponent } from './dispute/dispute.component';

export const routes: Routes = [
    {
        path: 'login',
        component: LoginComponent
    },
    {
        path: 'dispute',
        component: DisputeComponent
    }
];
