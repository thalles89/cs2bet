import { Component } from '@angular/core';
import { MatButton } from '@angular/material/button';
import {MatCardModule} from '@angular/material/card';
@Component({
  selector: 'app-dispute',
  standalone: true,
  imports: [MatCardModule, MatButton],
  templateUrl: './dispute.component.html',
  styleUrl: './dispute.component.scss'
})
export class DisputeComponent {

}
