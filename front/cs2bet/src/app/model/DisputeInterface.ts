export interface Dispute {
    beginAt: number;
    endAt: number;
    team1: string;
    team2: string;
    image1: string;
    image2: string;
    totalAmmount1: number;
    totalAmmount2: number;
    totalVotes1: number;
    totalVotes2: number;
    winner: number;
    commissionPayed: boolean;
}

